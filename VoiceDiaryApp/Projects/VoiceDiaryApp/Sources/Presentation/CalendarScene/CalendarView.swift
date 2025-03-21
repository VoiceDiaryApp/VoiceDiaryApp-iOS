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
    var currentDatePublisher = CurrentValueSubject<Date, Never>(Date())
    
    private let diaryManager: RealmDiaryManager
    
    private var diaryEntriesSubject = CurrentValueSubject<[WriteDiaryEntry], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Properties
    private var selectedDateSubject = CurrentValueSubject<Date?, Never>(nil)
    
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendar = Calendar.current
    var currentDate: Date = Date()
    private var diaryEntries: [WriteDiaryEntry] = []
    private var selectedDate: Date? = Date()
    
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
    
    init(frame: CGRect, diaryManager: RealmDiaryManager) {
        self.diaryManager = diaryManager
        super.init(frame: frame)
        setupUI()
        setupDaysOfWeek()
        addSwipeGestures()
        bindDataToCollectionView()
        
        selectedDatePublisher.send(selectedDate)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
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
            label.font = UIFont(name: FontType.RobotoRegular.rawValue, size: 13)
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
    
    func moveToMonth(byAddingMonths months: Int, direction: CATransitionSubtype) {
        guard let newDate = calendar.date(byAdding: .month, value: months, to: currentDate) else { return }

        currentDate = newDate
        currentDatePublisher.send(currentDate)

        animateCalendarTransition(direction: direction)

        let isCurrentMonth = calendar.isDate(newDate, equalTo: Date(), toGranularity: .month)

        selectedDate = isCurrentMonth ? Date() : calendar.date(from: Calendar.current.dateComponents([.year, .month], from: newDate))
        selectedDatePublisher.send(selectedDate)

        collectionView.reloadData()
    }

    private func animateCalendarTransition(direction: CATransitionSubtype) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        collectionView.layer.add(transition, forKey: kCATransition)
    }
    
    private func updateYearAndMonthLabels() {
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        (superview as? CalendarSummaryView)?.yearLabel.text = "\(year)년"
        (superview as? CalendarSummaryView)?.monthLabel.text = "\(month)월"
    }
    
    func highlightSelectedDate(date: Date?) {
        selectedDatePublisher.send(date)
    }
    
    func updateDiaryEntries(_ entries: [WriteDiaryEntry]) {
        diaryEntriesSubject.send(entries)
        collectionView.reloadData()
    }
    
    func bindDataToCollectionView() {
        Publishers.CombineLatest(diaryEntriesSubject, selectedDatePublisher)
            .sink { [weak self] (entries, selectedDate) in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        currentDatePublisher
            .sink { [weak self] currentDate in
                guard let self = self else { return }

                let isCurrentMonth = calendar.isDate(currentDate, equalTo: Date(), toGranularity: .month)
                self.selectedDate = isCurrentMonth ? Date() : calendar.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))
                self.selectedDatePublisher.send(self.selectedDate)

                self.updateYearAndMonthLabels()
            }
            .store(in: &cancellables)
    }
    
    func updateMonth(date: Date) {
        currentDate = date
        currentDatePublisher.send(currentDate)
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
            cell.configure(day: nil, date: firstDayOfMonth, diaryManager: diaryManager, isToday: false)
            cell.setSelected(false, isToday: false)
        } else {
            let day = indexPath.item - weekdayOffset + 1
            let cellDate = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            let isToday = calendar.isDateInToday(cellDate)
            let isSelected = calendar.isDate(cellDate, inSameDayAs: selectedDate ?? Date())

            cell.configure(day: day, date: cellDate, diaryManager: diaryManager, isToday: isToday)
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

            if let selectedDate = newlySelectedDate,
               let calendarSummaryView = superview as? CalendarSummaryView {
                calendarSummaryView.viewModel.fetchDiary(for: selectedDate)
                calendarSummaryView.updateDiaryContentView(for: selectedDate, hasDiary: true)
            }

            collectionView.reloadData()
        }
    }
}
