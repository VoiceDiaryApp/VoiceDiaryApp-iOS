//
//  DiaryEntryCell.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import SnapKit

class DiaryEntryCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configure(with entry: DiaryEntry) {
        label.text = DateFormatter.localizedString(from: entry.date, dateStyle: .short, timeStyle: .none)
    }
}
