//
//  Diary2VC.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import Combine

final class Diary2VC: UIViewController {
    
    // MARK: - Properties
    
    private let diaryVM: DiaryVM
    private var cancellables = Set<AnyCancellable>()
    private var selectedEmotion: Emotion?
    private var tapDrawEnd = PassthroughSubject<(Emotion, String), Never>()
    
    // MARK: - View
    
    private let calendarSummaryView = Diary2View()
    
    // MARK: - Life Cycle
    
    init(viewModel: DiaryVM) {
        self.diaryVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = calendarSummaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindView()
        bindViewModel()
        bindActions()
    }
}

private extension Diary2VC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        calendarSummaryView.navigationBar.backButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func bindViewModel() {
        let input = DiaryVM.Input(
            onRecording: PassthroughSubject(),
            tapRecordEnd: PassthroughSubject(),
            tapDrawEnd: self.tapDrawEnd,
            viewWillAppear: PassthroughSubject()
        )
        let _ = diaryVM.transform(input: input)
    }
    
    func bindView() {
        calendarSummaryView.isSaveEnabledPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isSaveEnabled in
                self?.calendarSummaryView.updateSaveButtonState(isEnabled: isSaveEnabled)
            }
            .store(in: &cancellables)
        
        calendarSummaryView.selectedEmotionSubject
            .sink { emotion in
                self.selectedEmotion = emotion
            }
            .store(in: &cancellables)
    }
    
    func bindActions() {
        calendarSummaryView.saveButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let filePath = self.saveImageToDocuments(image: self.captureCanvasView() ?? UIImage(), fileName: "\(getCurrentTimestamp()).jpeg")
                self.tapDrawEnd.send((self.selectedEmotion ?? Emotion.happy, filePath))
                
                let loadingVC = LoadingVC(viewModel: self.diaryVM)
                self.navigationController?.pushViewController(loadingVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    func captureCanvasView() -> UIImage? {
        let targetView = diaryView.canvasView
        return targetView.snapshot()
    }
    
    func saveImageToDocuments(image: UIImage,
                              fileName: String) -> String {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try data.write(to: filePath)
                return filePath.path
            } catch {
                print("Failed to save image to documents: \(error)")
            }
        }
        return ""
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date())
    }
}
