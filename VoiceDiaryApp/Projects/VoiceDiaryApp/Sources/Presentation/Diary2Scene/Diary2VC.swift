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
    private let viewModel = Diary2VM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View
    private let diaryView = Diary2View()
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        bindViewModel()
        bindActions()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        diaryView.isSaveEnabledPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isSaveEnabled in
                self?.diaryView.updateSaveButtonState(isEnabled: isSaveEnabled)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions Binding
    private func bindActions() {
        diaryView.saveButton.tapPublisher
            .sink { [weak self] _ in
                let loadingVC = LoadingVC()
                self?.navigationController?.pushViewController(loadingVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
