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
        
        bindViewModel()
        bindActions()
    }
}

private extension Diary2VC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        
    }
    
    func bindActions() {
        diaryView.saveButton.tapPublisher
            .sink { [weak self] _ in
                let loadingVC = LoadingVC()
                self?.navigationController?.pushViewController(loadingVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
