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
    private let viewModel = Diary2ViewModel()
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
        diaryView.delegate = self
        bindViewModel()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        
    }
}

extension Diary2VC: Diary2ViewDelegate {
    func saveButtonTapped() {
        let loadingVC = LoadingVC()
        self.navigationController?.pushViewController(loadingVC, animated: true)
    }
}
