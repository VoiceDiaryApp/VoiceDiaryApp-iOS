//
//  SettingVC.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import Combine

class SettingVC: UIViewController {
    
    // MARK: - View
    private let settingView = SettingView()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        bindAlertToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupNavigationBar() {
        settingView.setNavigationBarBackAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func bindAlertToggle() {
        settingView.alertTogglePublisher
            .sink { isOn in
                print("Alert Toggle is now: \(isOn)")
                // 필요한 동작 추가 (예: UserDefaults 저장, 네트워크 호출 등)
            }
            .store(in: &cancellables)
    }
}
