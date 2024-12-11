//
//  CalendarView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

protocol CalendarViewDelegate: AnyObject {
    func calendarViewDidUpdateDate(_ calendarView: CalendarView, to date: Date)
}

class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: CalendarViewDelegate?
    
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private var diaryEntries: [DiaryEntry] = []
    private let calendar = Calendar.current
    private var currentDate: Date = Date()
    private var selectedDate: Date?
    
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
        addSwipeGestures()
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
            moveToNextMonth()
        } else if gesture.direction == .right {
            moveToPreviousMonth()
        }
    }
    
    private func moveToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = nextMonth
            delegate?.calendarViewDidUpdateDate(self, to: currentDate)
            animateCalendarTransition(to: nextMonth, direction: .fromRight)
        }
    }
    
    private func moveToPreviousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = previousMonth
            delegate?.calendarViewDidUpdateDate(self, to: currentDate)
            animateCalendarTransition(to: previousMonth, direction: .fromLeft)
        }
    }
    
    private func animateCalendarTransition(to newDate: Date, direction: CATransitionSubtype) {
        currentDate = newDate
        
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        collectionView.layer.add(transition, forKey: kCATransition)
        updateMonth(date: currentDate)
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

        if let selectedDate = selectedDate, calendar.isDate(selectedDate, equalTo: currentDate, toGranularity: .month) {
            highlightSelectedDate()
        }
    }
    
    private func highlightSelectedDate() {
        guard let selectedDate = selectedDate else { return }
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
        let day = calendar.component(.day, from: selectedDate)
        let selectedIndexPath = IndexPath(item: day + weekdayOffset - 1, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
            if let cell = self.collectionView.cellForItem(at: selectedIndexPath) as? CalendarCell {
                cell.setSelected(true)
            }
        }
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
            cell.configure(day: nil, emotion: nil, isToday: false)
            cell.setSelected(false)
        } else {
            let day = indexPath.item - weekdayOffset + 1
            let cellDate = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            let isToday = calendar.isDate(Date(), inSameDayAs: cellDate)
            let entry = diaryEntries.first { calendar.isDate($0.date, inSameDayAs: cellDate) }
            
            let isSelected = selectedDate != nil && calendar.isDate(selectedDate!, inSameDayAs: cellDate)
            
            cell.configure(day: day, emotion: entry?.emotion, isToday: isToday)
            cell.setSelected(isSelected)
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
            
            if newlySelectedDate != selectedDate {
                selectedDate = newlySelectedDate
                delegate?.calendarViewDidUpdateDate(self, to: newlySelectedDate!)
            }

            collectionView.reloadData()
        }
    }
}
