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
    private let settingView = SettingView()
    private var cancellables = Set<AnyCancellable>()
    private var deleteAlertView: UIView?

    // MARK: - Life Cycle
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        bindViewActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        settingView.setNavigationBarBackAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func bindViewActions() {
        settingView.alertTogglePublisher
            .sink { [weak self] isOn in
                self?.handleAlertToggle(isOn: isOn)
            }
            .store(in: &cancellables)
        
        settingView.alertChangePublisher
            .sink { [weak self] in
                self?.navigateToAlertChange()
            }
            .store(in: &cancellables)
        
        settingView.deleteActionPublisher
            .sink { [weak self] in
                self?.showDeleteAlert()
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    private func handleAlertToggle(isOn: Bool) {
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
    
    private func navigateToAlertChange() {
        let onboardingVC = OnboardingVC(buttonTitle: "변경하기")
        navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
    private func showDeleteAlert() {
        let alertView = CustomAlertView(frame: self.view.bounds)
        
        alertView.onCancel = { [weak self] in
            alertView.removeFromSuperview()
        }
        
        alertView.onDelete = { [weak self] in
            alertView.removeFromSuperview()
        }
        
        self.view.addSubview(alertView)
    }
    
    @objc private func dismissDeleteAlert() {
        deleteAlertView?.removeFromSuperview()
        deleteAlertView = nil
    }
}
