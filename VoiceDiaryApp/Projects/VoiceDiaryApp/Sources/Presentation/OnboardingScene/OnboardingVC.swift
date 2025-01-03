//
//  OnboardingVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/17/24.
//

import UIKit
import SnapKit
import Combine

final class OnboardingVC: UIViewController {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let buttonTitle: String
    
    @UserDefaultWrapper(key: "dailyNotificationTime", defaultValue: "") private(set) var dailyNotificationTime: String
    @UserDefaultWrapper(key: "isNotificationSet", defaultValue: false) private(set) var isNotificationSet: Bool
    
    // MARK: - UI Components
    
    private let onboardingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알람 시간 설정"
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardBold, size: 24)
        return label
    }()
    
    private let onboardingSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 일기를 쓰고 싶은 시간을 선택해주세요."
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardMedium, size: 15)
        return label
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        return picker
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(resource: .mainYellow)
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Life Cycles
    
    init(buttonTitle: String = "시작하기") {
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
}

private extension OnboardingVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = UIColor(resource: .mainBeige)
        
        startButton.setTitle(buttonTitle, for: .normal)
        
        startButton.tapPublisher
            .sink(receiveValue: {
                self.saveSelectedTime()
            })
            .store(in: &cancellables)
    }
    
    func setHierarchy() {
        view.addSubviews(onboardingTitleLabel,
                         onboardingSubTitleLabel,
                         timePicker,
                         startButton)
    }
    
    func setLayout() {
        onboardingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            $0.leading.equalToSuperview().inset(43)
        }
        
        onboardingSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(onboardingTitleLabel.snp.bottom).offset(17)
            $0.leading.equalTo(onboardingTitleLabel.snp.leading)
        }
        
        timePicker.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 64)
            $0.height.equalTo(217)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 86)
            $0.height.equalTo(57)
        }
    }
    
    func changeRootToHomeVC() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        keyWindow.rootViewController = UINavigationController(rootViewController: HomeVC())
    }
    
    private func saveSelectedTime() {
        let selectedDate = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: selectedDate)
        
        NotificationManager.shared.requestAuthorization { [weak self] granted in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if granted {
                    self.dailyNotificationTime = formattedTime
                    self.isNotificationSet = true
                    NotificationManager.shared.scheduleDailyNotification(time: formattedTime)
                    self.changeRootToHomeVC()
                } else {
                    let alert = UIAlertController(
                        title: "알림 권한 비활성화",
                        message: "알림 권한을 허용하지 않으면 알림을 받을 수 없습니다. 앱 설정에서 권한을 활성화해주세요.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
                        self.changeRootToHomeVC()
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
