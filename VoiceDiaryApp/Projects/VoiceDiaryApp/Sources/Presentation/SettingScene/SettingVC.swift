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
        bindAlertChangeAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                
                if isOn {
                    if let savedTime = UserDefaults.standard.string(forKey: "dailyNotificationTime") {
                        NotificationManager.shared.scheduleDailyNotification(time: savedTime)
                    } else {
                        print("알림 시간이 설정되지 않았습니다.")
                    }
                } else {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
                UserDefaults.standard.set(isOn, forKey: "isNotificationEnabled")
            }
            .store(in: &cancellables)
    }
    
    private func bindAlertChangeAction() {
        settingView.alertChangePublisher
            .sink { [weak self] in
                let onboardingVC = OnboardingVC(buttonTitle: "변경하기")
                self?.navigationController?.pushViewController(onboardingVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
