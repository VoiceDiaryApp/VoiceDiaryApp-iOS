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
    private var currentDate: Date = Date()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        return collectionView
    }()

    private let daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
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
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(33)
            make.height.equalTo(32)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(daysStackView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(33)
            make.bottom.equalToSuperview()
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

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func updateDiaryEntries(_ entries: [DiaryEntry]) {
        diaryEntries = entries
        collectionView.reloadData()
    }

    func updateMonth(date: Date) {
        currentDate = date
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!.count
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return range + weekdayOffset
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
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
        let totalHorizontalPadding: CGFloat = 66
        let availableWidth = bounds.width - totalHorizontalPadding
        let cellWidth = floor(availableWidth / 7)\

        return CGSize(width: cellWidth, height: cellWidth + 32)
    }
}
