//
//  CalendarView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class CalendarView: UIView {
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendar = Calendar.current
    private var diaryEntries: [DiaryEntry] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        createDaysOfWeekLabels()
    }

    func updateCalendar(with entries: [DiaryEntry], year: Int, month: Int) {
        diaryEntries = entries
        createCalendarGrid(year: year, month: month)
    }

    private func createDaysOfWeekLabels() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 2

        for day in daysOfWeek {
            let label = UILabel()
            label.text = day
            label.textColor = UIColor(named: "CalendarTextBlack") ?? .black
            label.font = UIFont(name: "Roboto-Regular", size: 13)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
    }

    private func createCalendarGrid(year: Int, month: Int) {
        subviews.forEach { if $0 is UIStackView && $0 !== subviews[0] { $0.removeFromSuperview() } }

        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        let firstWeekday = calendar.component(.weekday, from: startDate) - 1

        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 2

        var currentDay = 1 - firstWeekday

        for _ in 0..<6 {
            let weekStackView = UIStackView()
            weekStackView.axis = .horizontal
            weekStackView.distribution = .fillEqually
            weekStackView.spacing = 2

            for _ in 1...7 {
                let dayContainer = UIView()
                if currentDay > 0 && currentDay <= range.count {
                    configureDayCell(dayContainer, day: currentDay, startDate: startDate)
                }
                weekStackView.addArrangedSubview(dayContainer)
                currentDay += 1
            }

            gridStackView.addArrangedSubview(weekStackView)
        }

        addSubview(gridStackView)
        gridStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureDayCell(_ dayContainer: UIView, day: Int, startDate: Date) {
        let entry = diaryEntries.first {
            Calendar.current.isDate($0.date, inSameDayAs: startDate.addingTimeInterval(Double((day - 1) * 86400)))
        }

        if let entry = entry {
            let imageView = UIImageView(image: UIImage(named: entry.emotion.rawValue))
            dayContainer.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.height.width.equalTo(41)
            }
        }

        let label = UILabel()
        label.text = "\(day)"
        label.textAlignment = .center
        dayContainer.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(dayContainer.snp.centerY)
            make.centerX.equalToSuperview()
        }
    }
}
