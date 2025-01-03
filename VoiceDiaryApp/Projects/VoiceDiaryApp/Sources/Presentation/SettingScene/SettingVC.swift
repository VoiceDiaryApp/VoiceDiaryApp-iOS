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
    
    let onboardingVC = OnboardingVC(buttonTitle: "변경하기")
    
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
        let isNotificationEnabled = UserDefaults.standard.bool(forKey: "isNotificationEnabled")
        settingView.updateAlertToggleState(isNotificationEnabled)
        
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
        NotificationManager.shared.isNotificationAuthorized { [weak self] authorized in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if authorized {
                    if isOn {
                        self.navigationController?.pushViewController(self.onboardingVC, animated: true)
                    } else {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                    UserDefaults.standard.set(isOn, forKey: "isNotificationEnabled")
                } else {
                    let alert = UIAlertController(
                        title: "알림 권한 비활성화",
                        message: "알림 권한이 비활성화되어 있습니다. 설정에서 권한을 활성화해주세요.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.settingView.updateAlertToggleState(false)
                }
            }
        }
    }
    
    private func navigateToAlertChange() {
        NotificationManager.shared.isNotificationAuthorized { [weak self] authorized in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if authorized {
                    self.navigationController?.pushViewController(self.onboardingVC, animated: true)
                } else {
                    let alert = UIAlertController(
                        title: "알림 권한 비활성화",
                        message: "알림 권한이 비활성화되어 있습니다. 설정에서 권한을 활성화해주세요.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.settingView.updateAlertToggleState(false)
                    self.navigationController?.pushViewController(self.onboardingVC, animated: true)
                }
            }
        }
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
