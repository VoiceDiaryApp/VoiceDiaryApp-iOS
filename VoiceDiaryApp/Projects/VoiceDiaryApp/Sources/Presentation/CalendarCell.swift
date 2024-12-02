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
            make.top.equalTo(emojiImageView.snp.bottom).offset(8)
            self.leadingConstraint = make.leading.equalToSuperview().inset(16).constraint
            self.trailingConstraint = make.trailing.equalToSuperview().inset(16).constraint
        }
    }

    func configure(day: Int?, emotion: Emotion?) {
        if let day = day {
            dayLabel.text = "\(day)"
            emojiImageView.image = UIImage(named: emotion?.rawValue ?? "defaultImage")
            
            // 숫자의 자리수에 따라 패딩 조정
            let isDoubleDigit = day >= 10
            leadingConstraint?.update(inset: isDoubleDigit ? 12 : 16)
            trailingConstraint?.update(inset: isDoubleDigit ? 12 : 16)
        } else {
            dayLabel.text = nil
            emojiImageView.image = nil
        }
    }
}
