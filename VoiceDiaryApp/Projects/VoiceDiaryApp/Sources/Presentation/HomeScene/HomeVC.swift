//
//  HomeVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/29/24.
//

import UIKit

import SnapKit
import Combine

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let todayDate = Date()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private lazy var todayWeekLabel: UILabel = {
        let label = UILabel()
        label.text = getFormattedDate(from: todayDate).weekday
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardBold, size: 20)
        return label
    }()
    
    private lazy var todayDateLabel: UILabel = {
        let label = UILabel()
        label.text = getFormattedDate(from: todayDate).formattedDate
        return label
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnSetting), for: .normal)
        return button
    }()
    
    private let todayBubbleImage = UIImageView(image: UIImage(resource: .imgHome))
    
    private let todayMentLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 어떤 하루였어?"
        label.font = .fontGuide(type: .PretandardMedium, size: 20)
        return label
    }()
    
    private let characterImageView = UIImageView(image: UIImage(resource: .imgCharacter))
    
    private let goToDiaryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnGoDiary), for: .normal)
        button.setImage(UIImage(resource: .btnGoDiaryDisabled), for: .disabled)
        return button
    }()
    
    private let goToCalendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnGoCalendar), for: .normal)
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
}

private extension HomeVC {
    
    func setUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        goToDiaryButton.tapPublisher
            .sink { _ in
                let dirayVC = DiaryVC()
                self.navigationController?.pushViewController(dirayVC, animated: true)
            }
            .store(in: &cancellables)
        
        goToCalendarButton.tapPublisher
            .sink { _ in
                let calendarVC = CalendarVC()
                self.navigationController?.pushViewController(calendarVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    func getFormattedDate(from date: Date) -> (formattedDate: String, 
                                               weekday: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let formattedDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEEE"
        
        let weekday = dateFormatter.string(from: date)
        
        return (formattedDate, weekday)
    }
    
    func setHierarchy() {
        view.addSubviews(todayWeekLabel,
                         todayDateLabel,
                         settingButton,
                         todayBubbleImage,
                         characterImageView,
                         goToDiaryButton,
                         goToCalendarButton)
        
        todayBubbleImage.addSubview(todayMentLabel)
    }
    
    func setLayout() {
        todayWeekLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(SizeLiterals.calSupporHeight(height: 24))
            $0.leading.equalToSuperview().inset(43)
        }
        
        todayDateLabel.snp.makeConstraints {
            $0.top.equalTo(todayWeekLabel.snp.bottom).offset(5)
            $0.leading.equalTo(todayWeekLabel.snp.leading)
        }
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(21)
        }
        
        todayBubbleImage.snp.makeConstraints {
            $0.top.equalTo(todayDateLabel.snp.bottom).offset(54)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(221)
            $0.height.equalTo(76)
        }
        
        todayMentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(17)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(todayMentLabel.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(195)
            $0.height.equalTo(226)
        }
        
        goToDiaryButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-SizeLiterals.calSupporHeight(height: 110))
            $0.leading.equalToSuperview().inset(41)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 101) / 2)
            $0.height.equalTo(120)
        }
        
        goToCalendarButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-SizeLiterals.calSupporHeight(height: 110))
            $0.trailing.equalToSuperview().inset(41)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 101) / 2)
            $0.height.equalTo(120)
        }
    }
}
