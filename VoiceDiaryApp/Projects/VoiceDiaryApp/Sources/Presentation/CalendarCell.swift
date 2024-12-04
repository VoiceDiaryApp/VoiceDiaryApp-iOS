//
//  CalendarCell.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class CalendarCell: UICollectionViewCell {

    private let dayLabel = UILabel()
    private let emojiImageView = UIImageView()

    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(emojiImageView)
        contentView.addSubview(dayLabel)

        emojiImageView.contentMode = .scaleAspectFit
        emojiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(41)
        }

        dayLabel.font = .systemFont(ofSize: 13)
        dayLabel.textColor = UIColor(named: "CalendarTextBlack") ?? .black
        dayLabel.textAlignment = .center

        // 패딩 제약조건 저장
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
                // 오늘 날짜 스타일 - Bold 폰트 적용
                dayLabel.font = UIFont(name: "Roboto-Bold", size: 13) ?? .boldSystemFont(ofSize: 13)
                dayLabel.textColor = UIColor(named: "CalendarSelected") ?? .red
            } else {
                // 기본 스타일
                dayLabel.font = UIFont(name: "Roboto-Regular", size: 13) ?? .systemFont(ofSize: 13)
                dayLabel.textColor = UIColor(named: "CalendarTextBlack") ?? .black
                dayLabel.text = "\(day)"
            }
        } else {
            dayLabel.text = nil
            emojiImageView.image = nil
        }
    }
}
