//
//  DiaryView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class DiaryView: UIView, CalendarViewDelegate {

    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitle("캘린더")
        return navBar
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CalendarTextBlack")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        label.textAlignment = .center
        return label
    }()

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CalendarTextBlack")
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()

    private let leftArrowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "CalendarTextBlack")
        button.transform = CGAffineTransform(rotationAngle: .pi)
        return button
    }()

    private let rightArrowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "CalendarTextBlack")
        return button
    }()

    let calendarView: CalendarView = CalendarView()
    
    private let diaryContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private let diaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "일기 제목"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        label.attributedText = NSMutableAttributedString(string: "일기 제목", attributes: [
            .kern: -0.5,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()

    private let diaryDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "CalendarTextBlack")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        label.attributedText = NSMutableAttributedString(string: "11월 19일", attributes: [
            .kern: -0.5,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()

    private let diaryContentLabel: UILabel = {
        let label = UILabel()
        label.text = """
        이런 내용을 썼대요 ~ 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 이런 내용을 썼대요 ~ 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고 어쩌고 저쩌고
        """
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.29
        label.attributedText = NSMutableAttributedString(string: label.text ?? "", attributes: [
            .kern: -0.5,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()

    private var currentDate: Date = Date() // 현재 선택된 날짜

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDateLabels()
        setupActions()
        setupDiaryContentView()
        calendarView.delegate = self // Delegate 연결
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "mainBeige")

        addSubview(navigationBar)
        addSubview(yearLabel)
        addSubview(monthLabel)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(calendarView)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        leftArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel.snp.centerY).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.width.height.equalTo(24)
        }

        rightArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel.snp.centerY).offset(10)
            make.trailing.equalToSuperview().offset(-28)
            make.width.height.equalTo(24)
        }

        calendarView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureDateLabels() {
        let calendar = Calendar.current
        yearLabel.text = "\(calendar.component(.year, from: currentDate))년"
        monthLabel.text = "\(calendar.component(.month, from: currentDate))월"
        calendarView.updateMonth(date: currentDate)

        updateDiaryDateLabel(for: currentDate)
    }

    private func setupActions() {
        leftArrowButton.addTarget(self, action: #selector(didTapLeftArrow), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(didTapRightArrow), for: .touchUpInside)
    }

    @objc private func didTapLeftArrow() {
        animateCalendarTransition(byAddingMonths: -1, direction: .fromLeft)
    }

    @objc private func didTapRightArrow() {
        animateCalendarTransition(byAddingMonths: 1, direction: .fromRight)
    }

    private func animateCalendarTransition(byAddingMonths months: Int, direction: CATransitionSubtype) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: months, to: currentDate) {
            currentDate = newDate
            let transition = CATransition()
            transition.type = .push
            transition.subtype = direction
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            calendarView.layer.add(transition, forKey: kCATransition)
            configureDateLabels()
        }
    }

    // CalendarViewDelegate 메서드 구현
    func calendarViewDidUpdateDate(_ calendarView: CalendarView, to date: Date) {
        currentDate = date
        configureDateLabels()
        updateDiaryDateLabel(for: date)
    }
    
    private func setupDiaryContentView() {
        addSubview(diaryContentView)
        diaryContentView.addSubview(diaryTitleLabel)
        diaryContentView.addSubview(diaryDateLabel)
        diaryContentView.addSubview(diaryContentLabel)
        
        diaryContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(174)
            make.bottom.equalToSuperview()
        }

        diaryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryContentView.snp.top).offset(22)
            make.leading.equalTo(diaryContentView.snp.leading).offset(37)
        }

        diaryDateLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(diaryTitleLabel.snp.leading)
        }

        diaryContentLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryDateLabel.snp.bottom).offset(13)
            make.leading.equalTo(diaryContentView.snp.leading).offset(36)
            make.trailing.equalTo(diaryContentView.snp.trailing).offset(-36)
        }
    }
    
    private func updateDiaryDateLabel(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        diaryDateLabel.text = formatter.string(from: date)
    }
}
