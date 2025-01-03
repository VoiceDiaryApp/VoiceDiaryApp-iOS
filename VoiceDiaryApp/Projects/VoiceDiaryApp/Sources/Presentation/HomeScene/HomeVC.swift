//
//  HomeVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/29/24.
//

import UIKit

import SnapKit
import Combine
import RealmSwift

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let todayDate = Date()
    private var cancellables = Set<AnyCancellable>()
    private let realmManager = RealmDiaryManager()
    private let isIpad = DeviceUtils.isIPad()
    
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
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
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
        label.font = .fontGuide(type: .GangwonEduSaeeum, size: 30)
        return label
    }()
    
    private let characterImageView = UIImageView(image: UIImage(resource: .imgCharacter))
    
    private let goToDiaryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .mainYellow)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let goToDiaryImageView = UIImageView(image: UIImage(resource: .icDiary))
    
    private let goToDiaryStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = SizeLiterals.calSupporHeight(height: 5)
        stackview.alignment = .center
        return stackview
    }()
    
    private lazy var goToDiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "일기 쓰러 가기"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private let goToCalendarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .mainYellow)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let goToCalendarStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = SizeLiterals.calSupporHeight(height: 5)
        stackview.alignment = .center
        return stackview
    }()
    
    private let goToCalendarImageView = UIImageView(image: UIImage(resource: .icCalendar))
    
    private lazy var goToCalendarLabel: UILabel = {
        let label = UILabel()
        label.text = "캘린더"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let hasTodayDiary = realmManager.hasTodayDiary()
        goToDiaryView.backgroundColor = hasTodayDiary ? UIColor(resource: .mainYellow).withAlphaComponent(0.5) : UIColor(resource: .mainYellow)
        goToDiaryLabel.textColor = hasTodayDiary ? .black.withAlphaComponent(0.5) : .black
        todayMentLabel.text = hasTodayDiary ? "내일은 어떤 하루일까?" : "오늘은 어떤 하루였어?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
}

private extension HomeVC {
    
    func setUI() {
        view.backgroundColor = UIColor(resource: .mainBeige)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        characterImageView.contentMode = .scaleAspectFit
        
        let hasTodayDiary = realmManager.hasTodayDiary()
        goToDiaryView.isUserInteractionEnabled = !hasTodayDiary
        
        goToDiaryView.tapGesturePublisher()
            .sink { _ in
                let dirayVC = DiaryVC()
                self.navigationController?.pushViewController(dirayVC, animated: true)
            }
            .store(in: &cancellables)
        
        goToCalendarView.tapGesturePublisher()
            .sink { _ in
                let calendarVC = CalendarVC()
                self.navigationController?.pushViewController(calendarVC, animated: true)
            }
            .store(in: &cancellables)
        
        settingButton.tapPublisher
            .sink { _ in
                let settingVC = SettingVC()
                self.navigationController?.pushViewController(settingVC, animated: true)
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
                         goToDiaryView,
                         goToCalendarView)
        
        todayBubbleImage.addSubview(todayMentLabel)
        goToDiaryView.addSubviews(goToDiaryStackView)
        goToDiaryStackView.addArrangedSubviews(goToDiaryImageView,
                                               goToDiaryLabel)
        goToCalendarView.addSubviews(goToCalendarStackView)
        goToCalendarStackView.addArrangedSubviews(goToCalendarImageView,
                                                  goToCalendarLabel)
        
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
            $0.top.equalTo(todayWeekLabel.snp.top)
            $0.trailing.equalToSuperview().inset(21)
            $0.size.equalTo(30)
        }
        
        todayBubbleImage.snp.makeConstraints {
            $0.top.equalTo(todayDateLabel.snp.bottom).offset(54)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(221)
            $0.height.equalTo(76)
        }
        
        todayMentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(todayMentLabel.snp.bottom).offset(SizeLiterals.calSupporHeight(height: 34))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(isIpad ? 400 : 196)
            $0.height.equalTo(isIpad ? 461 : 226)
        }
        
        goToDiaryView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-SizeLiterals.calSupporHeight(height: 110))
            $0.leading.equalToSuperview().inset(41)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 101) / 2)
            $0.height.equalTo(SizeLiterals.calSupporHeight(height: 120))
        }
        
        goToDiaryStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        goToDiaryImageView.snp.makeConstraints {
            $0.size.equalTo(isIpad ? 100 : 66)
        }
        
        goToCalendarView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-SizeLiterals.calSupporHeight(height: 110))
            $0.trailing.equalToSuperview().inset(41)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 101) / 2)
            $0.height.equalTo(SizeLiterals.calSupporHeight(height: 120))
        }
        
        goToCalendarImageView.snp.makeConstraints {
            $0.size.equalTo(isIpad ? 100 : 66)
        }
        
        goToCalendarStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
