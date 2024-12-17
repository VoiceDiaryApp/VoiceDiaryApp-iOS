//
//  SettingVC.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import Combine

class SettingVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = Diary2ViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View
    private let settingView = SettingView()
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        bindViewModel()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        
    }
}
