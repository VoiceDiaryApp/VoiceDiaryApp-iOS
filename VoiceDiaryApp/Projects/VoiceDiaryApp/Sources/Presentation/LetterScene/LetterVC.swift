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

final class LetterVC: UIViewController {
    
    // MARK: - Properties
    
    private let diaryVM: DiaryVM
    private var cancellables = Set<AnyCancellable>()
    private let viewWillAppear: PassthroughSubject<Void, Never> = PassthroughSubject()
    
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
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .fontGuide(type: .NanumHand, size: 25)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: DiaryVM) {
        self.diaryVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppear.send()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        bindViewModel()
    }
}

private extension LetterVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(resource: .mainBeige)
        
        navigationBar.exitButtonAction = {
            self.changeRootToHomeVC()
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
            .sink(receiveValue: { letter in
                self.letterLabel.text = letter
        })
        .store(in: &cancellables)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         characterImageView,
                         letterView)
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
            $0.width.equalTo(209)
            $0.height.equalTo(158)
        }
        
        letterView.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 71)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-19)
        }
        
        letterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(41)
            $0.leading.trailing.equalToSuperview().inset(33)
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
}
