//
//  CalendarCell.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

final class CalendarCell: UICollectionViewCell {

    // MARK: Properties
    private let dayLabel = UILabel()
    private let emojiImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubviews(emojiImageView, dayLabel)

        emojiImageView.contentMode = .scaleAspectFit
        emojiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(41)
        }

        dayLabel.font = .fontGuide(type: .PretandardRegular, size: 13)
        dayLabel.textColor = UIColor(resource: .calendarTextBlack)
        dayLabel.textAlignment = .center
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiImageView.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(32)
        }
    }

    func configure(day: Int?, date: Date, diaryManager: RealmDiaryManager, isToday: Bool) {
        if let day = day {
            dayLabel.text = "\(day)"
            
            if let diaryEntry = diaryManager.fetchDiaryEntry(for: date),
               let emotion = Emotion(rawValue: diaryEntry.emotion) {
                emojiImageView.image = UIImage(named: emotion.rawValue)
            } else {
                emojiImageView.image = UIImage(named: "defaultImage")
            }

            if isToday {
                dayLabel.font = .fontGuide(type: .RobotobBold, size: 13)
                dayLabel.textColor = UIColor(resource: .calendarSelected)
            } else {
                dayLabel.font = .fontGuide(type: .RobotoRegular, size: 13)
                dayLabel.textColor = UIColor(resource: .calendarTextBlack)
            }
        } else {
            dayLabel.text = nil
            emojiImageView.image = nil
        }
    }

    func setSelected(_ isSelected: Bool, isToday: Bool) {
        contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

        if isSelected {
            dayLabel.textColor = .white
            let selectedBackground = UIView()
            selectedBackground.tag = 999
            selectedBackground.backgroundColor = UIColor(resource: .calendarSelected)
            selectedBackground.layer.cornerRadius = 8
            contentView.insertSubview(selectedBackground, belowSubview: dayLabel)
            selectedBackground.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(25)
                make.height.equalTo(21)
                make.centerY.equalTo(dayLabel)
            }
        } else {
            dayLabel.textColor = isToday
                ? UIColor(resource: .calendarSelected)
                : UIColor(resource: .calendarTextBlack)
        }
    }
}
