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
    private var tapDrawEnd = PassthroughSubject<Emotion, Never>()
    
    // MARK: - View
    
    private let diaryView = Diary2View()
    
    // MARK: - Life Cycle
    
    init(viewModel: DiaryVM) {
        self.diaryVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryView
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
        
        diaryView.navigationBar.backButtonAction = {
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
        diaryView.isSaveEnabledPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isSaveEnabled in
                self?.diaryView.updateSaveButtonState(isEnabled: isSaveEnabled)
            }
            .store(in: &cancellables)
        
        diaryView.selectedEmotionSubject
            .sink { emotion in
                self.selectedEmotion = emotion
            }
            .store(in: &cancellables)
    }
    
    func bindActions() {
        diaryView.saveButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tapDrawEnd.send(self.selectedEmotion ?? Emotion.happy)
                let loadingVC = LoadingVC(viewModel: self.diaryVM)
                self.navigationController?.pushViewController(loadingVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
