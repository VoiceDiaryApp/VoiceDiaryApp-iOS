//
//  DiaryEntryCell.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import SnapKit

class DiaryEntryCell: UICollectionViewCell {
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
        contentView.addSubviews(dayLabel, emojiImageView)

        dayLabel.textAlignment = .center
        dayLabel.font = UIFont(name: "Roboto-Regular", size: 13)

        emojiImageView.contentMode = .scaleAspectFit

        dayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }

        emojiImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.height.width.equalTo(24)
        }
    }

}
