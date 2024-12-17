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

        dayLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        dayLabel.textColor = UIColor(resource: .calendarTextBlack)
        dayLabel.textAlignment = .center
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiImageView.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(32)
        }
    }

    func configure(day: Int?, emotion: Emotion?, isToday: Bool) {
        if let day = day {
            dayLabel.text = "\(day)"
            emojiImageView.image = UIImage(named: emotion?.rawValue ?? "defaultImage")

            if isToday {
                dayLabel.font = UIFont(name: "Roboto-Bold", size: 13)
                dayLabel.textColor = UIColor(resource: .calendarSelected)
            } else {
                dayLabel.font = UIFont(name: "Roboto-Regular", size: 13)
                dayLabel.textColor = UIColor(resource: .calendarTextBlack)
            }
        } else {
            dayLabel.text = nil
            emojiImageView.image = nil
        }
    }

    func setSelected(_ isSelected: Bool, isToday: Bool) {
        if isSelected {
            dayLabel.textColor = .white
            let selectedBackground = UIView()
            selectedBackground.backgroundColor = UIColor(resource: .calendarSelected)
            selectedBackground.layer.cornerRadius = 8
            contentView.insertSubview(selectedBackground, belowSubview: dayLabel)
            selectedBackground.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(25)
                make.height.equalTo(21)
                make.bottom.equalTo(dayLabel.snp.bottom).offset(-5)
            }
        } else {
            dayLabel.textColor = isToday
            ? UIColor(resource: .calendarSelected)
            : UIColor(resource: .calendarTextBlack)
            contentView.subviews.filter { $0 != dayLabel && $0 != emojiImageView }.forEach { $0.removeFromSuperview() }
        }
    }
}
