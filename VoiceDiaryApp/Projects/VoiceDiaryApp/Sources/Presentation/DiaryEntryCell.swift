//
//  DiaryEntryCell.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import SnapKit

class CalendarCell: UICollectionViewCell {

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
        // Add components to contentView
        contentView.addSubview(emojiImageView)
        contentView.addSubview(dayLabel)

        emojiImageView.contentMode = .scaleAspectFit
        emojiImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(41)
        }

        dayLabel.font = .systemFont(ofSize: 13)
        dayLabel.textColor = UIColor(named: "CalendarTextBlack")
        dayLabel.textAlignment = .center
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiImageView.snp.bo)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }

    }

    func configure(day: Int?, emotion: Emotion?, additionalImage: UIImage? = nil) {
        if let day = day {
            dayLabel.text = "\(day)"
            emojiImageView.image = UIImage(named: emotion?.rawValue ?? "defaultImage")
        } else {
            dayLabel.text = nil
            emojiImageView.image = nil
        }

    }
}
