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
    
    private let todayMentLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 어떤 하루였어?"
        return label
    }()
    
    private let characterImageView = UIImageView(image: UIImage(resource: .imgCharacter))
    
    private let goToDiaryButton: UIButton = {
        let button = UIButton()
        button.setTitle("일기 쓰러 가기", for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    private let goToCalendarButton: UIButton = {
        let button = UIButton()
        button.setTitle("캘린더", for: .normal)
        button.backgroundColor = .darkGray
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
        
        goToDiaryButton.tapPublisher
            .sink { _ in
                print("goToDiaryVC")
            }
            .store(in: &cancellables)
        
        goToCalendarButton.tapPublisher
            .sink { _ in
                print("goToCalendarVC")
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
                         todayMentLabel,
                         characterImageView,
                         goToDiaryButton,
                         goToCalendarButton)
    }
    
    func setLayout() {
        todayWeekLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().inset(43)
        }
        
        todayDateLabel.snp.makeConstraints {
            $0.top.equalTo(todayWeekLabel.snp.bottom).offset(5)
            $0.leading.equalTo(todayWeekLabel.snp.leading)
        }
        
        todayMentLabel.snp.makeConstraints {
            $0.top.equalTo(todayDateLabel.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(todayMentLabel.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(170)
            $0.height.equalTo(226)
        }
        
        goToDiaryButton.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(41)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 128) / 2)
            $0.height.equalTo(92)
        }
        
        goToCalendarButton.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(50)
            $0.trailing.equalToSuperview().inset(41)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 128) / 2)
            $0.height.equalTo(92)
        }
    }
}
