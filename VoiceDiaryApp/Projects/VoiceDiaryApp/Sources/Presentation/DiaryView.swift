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
    
    private var currentDate: Date = Date() // 현재 선택된 날짜
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDateLabels()
        setupActions()
        calendarView.delegate = self
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
    }
    
    private func setupActions() {
        leftArrowButton.addTarget(self, action: #selector(didTapLeftArrow), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(didTapRightArrow), for: .touchUpInside)
    }
    
    @objc private func didTapLeftArrow() {
        updateCurrentDate(byAddingMonths: -1)
    }
    
    @objc private func didTapRightArrow() {
        updateCurrentDate(byAddingMonths: 1)
    }
    
    func calendarViewDidUpdateDate(_ calendarView: CalendarView, to date: Date) {
        currentDate = date
        configureDateLabels()
    }
    
    private func updateCurrentDate(byAddingMonths months: Int) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: months, to: currentDate) {
            currentDate = newDate
            configureDateLabels()
            calendarView.updateMonth(date: currentDate)
        }
    }
}
