//
//  CalendarView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private var diaryEntries: [DiaryEntry] = []
    private let calendar = Calendar.current
    private let now = Date()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        return collectionView
    }()

    private let daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDaysOfWeek()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(daysStackView)
        addSubview(collectionView)

        daysStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(32)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(daysStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }

    private func setupDaysOfWeek() {
        daysOfWeek.forEach { day in
            let label = UILabel()
            label.text = day
            label.textColor = UIColor(named: "CalendarTextBlack") ?? .black
            label.font = UIFont(name: "Roboto-Regular", size: 13)
            label.textAlignment = .center
            daysStackView.addArrangedSubview(label)
        }
    }

    func updateDiaryEntries(_ entries: [DiaryEntry]) {
        diaryEntries = entries
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let range = calendar.range(of: .day, in: .month, for: now)!.count
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return range + weekdayOffset
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1

        if indexPath.item < weekdayOffset {
            cell.configure(day: nil, emotion: nil)
        } else {
            let day = indexPath.item - weekdayOffset + 1
            let entry = diaryEntries.first { calendar.component(.day, from: $0.date) == day }
            cell.configure(day: day, emotion: entry?.emotion)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 7
        return CGSize(width: width, height: width + 30)
    }
}
