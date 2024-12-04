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
    private var currentDate: Date = Date() // 현재 표시 중인 날짜

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2 // 줄 간격
        layout.minimumInteritemSpacing = 0 // 칸 간격
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
        stackView.spacing = 0 // 간격 없음
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
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(32) // 고정 높이
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(daysStackView.snp.bottom).offset(2) // 2 아래
            make.leading.trailing.bottom.equalToSuperview()
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

    // 현재 표시 중인 달을 업데이트
    func updateMonth(date: Date) {
        currentDate = date
        collectionView.reloadData()
    }

    // 표시할 셀 수 계산 (달의 시작 요일과 날짜 범위 포함)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!.count
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return range + weekdayOffset
    }

    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1

        if indexPath.item < weekdayOffset {
            // 시작 요일 전의 빈 공간
            cell.configure(day: nil, emotion: nil)
        } else {
            let day = indexPath.item - weekdayOffset + 1
            let entry = diaryEntries.first { calendar.component(.day, from: $0.date) == day }
            cell.configure(day: day, emotion: entry?.emotion)
        }

        return cell
    }

    // 셀 크기 계산
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: width + 32) // 감정 이미지 + 날짜 텍스트
    }
}
