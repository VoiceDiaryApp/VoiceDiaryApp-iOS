//
//  LetterVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/17/24.
//


import UIKit

import SnapKit
import Photos
import Combine
import RealmSwift

final class LetterVC: UIViewController {
    
    // MARK: - Properties
    
    private let diaryVM: DiaryVM
    private let selectedDate: Date?
    private let isFromCalendar: Bool
    private var cancellables = Set<AnyCancellable>()
    private let viewWillAppear: PassthroughSubject<Date, Never> = PassthroughSubject()
    
    // MARK: - UI Components
    
    private let navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.isBackButtonIncluded = false
        navigationBar.isExitButtonIncluded = true
        navigationBar.isSaveButtonIncluded = true
        navigationBar.setTitleLabel = "깨비의 답장"
        return navigationBar
    }()
    
    private let characterImageView = UIImageView(image: UIImage(resource: .imgLetterCharacter))
    
    private let letterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(resource: .calendarSelected).cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .fontGuide(type: .GangwonEduSaeeum, size: 22)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "똑깨비"
        label.textColor = UIColor(resource: .calendarSelected)
        label.font = .fontGuide(type: .GangwonEduSaeeum, size: 22)
        label.textAlignment = .center
        label.setOutline(outlineColor: UIColor(resource: .calendarSelected), outlineWidth: 1.5)
        return label
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: DiaryVM, selectedDate: Date? = nil, isFromCalendar: Bool = false) {
        self.diaryVM = viewModel
        self.selectedDate = selectedDate
        self.isFromCalendar = isFromCalendar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedDate = selectedDate {
            viewWillAppear.send(selectedDate)
        } else {
            viewWillAppear.send(Date())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        bindViewModel()
        printAllEntries()
    }
}

private extension LetterVC {
    
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(resource: .mainBeige)
        
        navigationBar.exitButtonAction = {
            if self.isFromCalendar {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.changeRootToHomeVC()
            }
        }
        
        navigationBar.saveButtonAction = {
            guard self.captureScreenshot() != nil else { return }
            
            self.checkPhotoLibraryPermission { granted in
                if granted {
                    guard let screenshot = self.captureScreenshot() else { return }
                    
                    UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(self.imageSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    print("사진 접근 권한이 없습니다.")
                }
            }
        }
    }
    
    func bindViewModel() {
        let input = DiaryVM.Input(
            onRecording: PassthroughSubject(),
            tapRecordEnd: PassthroughSubject(),
            tapDrawEnd: PassthroughSubject(),
            viewWillAppear: self.viewWillAppear
        )
        
        let output = diaryVM.transform(input: input)
        
        output.geminiLetter
            .sink(receiveValue: { [weak self] letter in
                guard let self = self else { return }
                print("Received letter: \(letter)")
                let adjustedLetter = self.getAdjustedText(for: letter)
                print("Received adjustedletter: \(adjustedLetter)")
                self.letterLabel.text = adjustedLetter
            })
            .store(in: &cancellables)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         characterImageView,
                         letterView,
                         appNameLabel)
        letterView.addSubview(letterLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.calSupporHeight(height: 55))
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(DeviceUtils.isIPad() ? 355 : 209)
            $0.height.equalTo(DeviceUtils.isIPad() ? 268 : 158)
        }
        
        letterView.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            if DeviceUtils.isIPad() {
                $0.size.equalTo(SizeLiterals.Screen.screenWidth - 300)
            } else {
                $0.width.equalTo(SizeLiterals.Screen.screenWidth - 71)
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            }
        }
        
        letterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(37)
            $0.leading.trailing.equalToSuperview().inset(33)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.top.equalTo(letterView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
    
    func captureScreenshot() -> UIImage? {
        let targetView = view.snapshot(of: CGRect(
            origin: CGPoint(x: 0, y: navigationBar.frame.maxY),
            size: CGSize(width: view.frame.width, height: view.frame.height - navigationBar.frame.maxY)
        ))
        
        return targetView
    }
    
    @objc func imageSaveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("이미지 저장 실패: \(error.localizedDescription)")
            self.showNotSaveAlert()
        } else {
            print("이미지 저장 성공")
            self.showSaveAlert()
        }
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            showSettingsAlert()
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        completion(true)
                    } else {
                        self.showSettingsAlert()
                        completion(false)
                    }
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "앱에서 사진을 저장하려면 사진 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showSaveAlert() {
        makeVibrate()
        let alertViewController = UIAlertController(
            title: "저장 완료",
            message: "깨비의 답장이 담긴 이미지가 저장되었어요. 갤러리에서 확인해보세요!",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.changeRootToHomeVC()
        }
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showNotSaveAlert() {
        makeVibrate()
        let alertViewController = UIAlertController(
            title: "저장 실패",
            message: "저장에 실패했어요. 다시 시도해주세요.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func changeRootToHomeVC() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        keyWindow.rootViewController = UINavigationController(rootViewController: HomeVC())
    }
    
    func printAllEntries() {
        do {
            let realm = try Realm()
            let allEntries = realm.objects(RealmDiaryEntry.self)
            print("😬😬😬😬😬")
            for entry in allEntries {
                print(entry)
            }
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
}

private extension LetterVC {
    
    func getAdjustedText(for text: String) -> String {
        
        var maxLabelWidth = 0.0
        var maxLabelHeight = 0.0
        if DeviceUtils.isIPad() {
            maxLabelWidth = SizeLiterals.Screen.screenWidth - 300 - 66
            maxLabelHeight = SizeLiterals.Screen.screenWidth - 300 - 74
        } else {
            maxLabelWidth = SizeLiterals.Screen.screenWidth - 71 - 66
            maxLabelHeight = SizeLiterals.Screen.screenHeight - 321 - 74
        }
        
        let font = UIFont.fontGuide(type: .GangwonEduSaeeum, size: 22)
        let sentences = splitIntoSentences(from: text)
        var adjustedText = ""
        
        for sentence in sentences {
            let newText = adjustedText.isEmpty ? sentence : "\(adjustedText) \(sentence)"
            let textBoundingRect = calculateTextBoundingRect(for: newText, maxWidth: maxLabelWidth, font: font)
            
            if textBoundingRect.height > maxLabelHeight {
                break
            }
            adjustedText = newText
        }
        return adjustedText
    }
    
    func calculateTextBoundingRect(for text: String,
                                   maxWidth: CGFloat,
                                   font: UIFont) -> CGRect {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return attributedText.boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
    }
    
    func splitIntoSentences(from text: String) -> [String] {
        let pattern = "(.*?[\\.\\!\\?])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        let matches = regex?.matches(
            in: text,
            options: [],
            range: NSRange(location: 0, length: text.utf16.count)
        ) ?? []
        
        return matches.map {
            let range = Range($0.range, in: text)!
            return String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
