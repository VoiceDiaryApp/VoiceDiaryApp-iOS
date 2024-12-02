//
//  DiaryView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class DiaryView: UIView {

    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitle("캘린더")
        return navBar
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    let calendarView: CalendarView = CalendarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDateLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "mainBeige")

        addSubview(navigationBar)
        addSubview(yearLabel)
        addSubview(monthLabel)
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

        calendarView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureDateLabels() {
        let calendar = Calendar.current
        let now = Date()
        yearLabel.text = "\(calendar.component(.year, from: now))년"
        monthLabel.text = "\(calendar.component(.month, from: now))월"
    }
}
