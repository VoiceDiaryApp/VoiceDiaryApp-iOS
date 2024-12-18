//
//  DetailView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/18/24.
//

import UIKit
import SnapKit

final class DetailView: UIView {

    // MARK: - UI Components

    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitleLabel = "나의 일기장"
        navBar.isBackButtonIncluded = true
        navBar.isLetterButtonIncluded = true
        return navBar
    }()

    let diaryHeaderView = DiaryHeaderView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = UIColor(resource: .mainBeige)
        addSubviews(navigationBar, diaryHeaderView)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        diaryHeaderView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

final class DiaryHeaderView: UIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontGuide(type: .PretandardSemiBold, size: 20)
        label.textColor = .black
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontGuide(type: .PretandardSemiBold, size: 17)
        label.textColor = UIColor(resource: .calendarTextBlack)
        return label
    }()

    private let emojiView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .clear
        addSubviews(titleLabel, dateLabel, emojiView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(31)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }

        emojiView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.top)
            make.trailing.equalToSuperview().inset(39)
            make.size.equalTo(46)
        }
    }

    // MARK: - Configuration

    func configure(title: String, date: String, emotion: Emotion) {
        titleLabel.text = title
        dateLabel.text = date
        emojiView.image = UIImage(named: emotion.rawValue)
    }
}
