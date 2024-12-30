//
//  CalendarView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit
import Combine

final class CalendarView: UIView {
    // MARK: - Combine
    var selectedDatePublisher = CurrentValueSubject<Date?, Never>(nil)
    
    private var diaryEntriesSubject = CurrentValueSubject<[CalendarEntry], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Properties
    private var selectedDateSubject = CurrentValueSubject<Date?, Never>(nil)
    
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendar = Calendar.current
    private var currentDate: Date = Date()
    private var diaryEntries: [CalendarEntry] = []
    private var selectedDate: Date?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
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
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDaysOfWeek()
        addSwipeGestures()
        bindDataToCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(daysStackView, collectionView)
        
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
            label.textColor = UIColor(resource: .calendarTextBlack)
            label.font = .fontGuide(type: .RobotoRegular, size: 13)
            label.textAlignment = .center
            daysStackView.addArrangedSubview(label)
        }
    }
    
    private func addSwipeGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            moveToMonth(byAddingMonths: 1, direction: .fromRight)
        } else if gesture.direction == .right {
            moveToMonth(byAddingMonths: -1, direction: .fromLeft)
        }
    }
    
    private func moveToMonth(byAddingMonths months: Int, direction: CATransitionSubtype) {
        if let newDate = calendar.date(byAdding: .month, value: months, to: currentDate) {
            currentDate = newDate
            animateCalendarTransition(direction: direction)
            collectionView.reloadData()
            updateYearAndMonthLabels()
        }
    }
    
    private func updateYearAndMonthLabels() {
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        (superview as? DiaryView)?.yearLabel.text = "\(year)년"
        (superview as? DiaryView)?.monthLabel.text = "\(month)월"
    }
    
    private func animateCalendarTransition(direction: CATransitionSubtype) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        collectionView.layer.add(transition, forKey: kCATransition)
    }
    
    func highlightSelectedDate(date: Date?) {
        selectedDatePublisher.send(date)
    }
    
    func updateDiaryEntries(_ entries: [CalendarEntry]) {
        diaryEntriesSubject.send(entries)
    }
    
    func bindDataToCollectionView() {
        Publishers.CombineLatest(diaryEntriesSubject, selectedDatePublisher)
            .sink { [weak self] (entries, selectedDate) in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func updateMonth(date: Date) {
        currentDate = date
        collectionView.reloadData()
    }
    
    
    
}

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
            return 0
        }
        
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return range.count + weekdayOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }

        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1

        if indexPath.item < weekdayOffset {
            cell.configure(day: nil, emotion: nil, isToday: false)
            cell.setSelected(false, isToday: false)
        } else {
            let day = indexPath.item - weekdayOffset + 1
            let cellDate = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            let isToday = calendar.isDateInToday(cellDate)
            let entry = diaryEntries.first { calendar.isDate($0.date, inSameDayAs: cellDate) }
            let isSelected = selectedDate != nil && calendar.isDate(selectedDate!, inSameDayAs: cellDate)

            cell.configure(day: day, emotion: entry?.emotion, isToday: isToday)
            cell.setSelected(isSelected, isToday: isToday)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalPadding: CGFloat = 66
        let availableWidth = bounds.width - totalHorizontalPadding
        let cellWidth = floor(availableWidth / 7)
        return CGSize(width: cellWidth, height: cellWidth + 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else { return }
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1

        if indexPath.item >= weekdayOffset {
            let day = indexPath.item - weekdayOffset + 1
            let newlySelectedDate = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
            
            selectedDate = newlySelectedDate
            selectedDatePublisher.send(newlySelectedDate)
            
            collectionView.reloadData()
        }
    }
}
