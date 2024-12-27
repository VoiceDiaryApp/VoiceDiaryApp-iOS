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
    private var deleteAlertView: UIView?

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
        bindDeleteAction()
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
    
    private func bindDeleteAction() {
        settingView.deleteActionPublisher
            .sink { [weak self] in
                self?.showDeleteAlert()
            }
            .store(in: &cancellables)
    }
    
    private func showDeleteAlert() {
        let dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDeleteAlert))
        dimView.addGestureRecognizer(tapGesture)
        self.view.addSubview(dimView)
        
        let alertContainer = UIView()
        self.view.addSubview(alertContainer)
        
        alertContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 8
        alertContainer.addSubview(dimView)
        alertContainer.addSubview(alertView)
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(37)
            make.height.equalTo(157)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "정말 모든 기록을 삭제하시겠습니까?"
        titleLabel.font = .fontGuide(type: .PretandardBold, size: 16)
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "이 작업은 되돌릴 수 없습니다.\n삭제를 진행하시겠습니까?"
        descriptionLabel.font = .fontGuide(type: .PretandardSemiBold, size: 12)
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        alertView.addSubview(descriptionLabel)
        
        let cancelButton = UIButton()
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 15)
        cancelButton.backgroundColor = UIColor(resource: .mainYellow)
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(dismissDeleteAlert), for: .touchUpInside)
        alertView.addSubview(cancelButton)
        
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 15)
        deleteButton.backgroundColor = UIColor(resource: .mainYellow)
        deleteButton.layer.cornerRadius = 8
        deleteButton.addTarget(self, action: #selector(dismissDeleteAlert), for: .touchUpInside)
        alertView.addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-18)
            make.trailing.equalTo(alertView.snp.centerX).offset(-11)
            make.size.equalTo(CGSize(width: 90, height: 40))
        }
        
        deleteButton.snp.makeConstraints { make in
        make.bottom.equalToSuperview().offset(-18)
            make.leading.equalTo(alertView.snp.centerX).offset(11)
            make.size.equalTo(CGSize(width: 90, height: 40))
        }
        
        self.deleteAlertView = alertContainer
    }
    
    @objc private func dismissDeleteAlert() {
        deleteAlertView?.removeFromSuperview()
        deleteAlertView = nil
    }
}
