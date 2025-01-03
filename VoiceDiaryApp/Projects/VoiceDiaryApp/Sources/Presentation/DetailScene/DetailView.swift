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

    private let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let diaryDrawingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(resource: .calendarSelected).cgColor
        view.layer.borderWidth = 2
        return view
    }()

    private let diaryTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardRegular, size: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "일기 내용이 여기에 표시됩니다.\n답장 레이블 높이는 내용에 따라 조정됩니다."
        return label
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
        backgroundColor = UIColor(resource: .mainBeige)
        addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubviews(navigationBar, diaryHeaderView, diaryImageView, diaryDrawingView)
        diaryDrawingView.addSubview(diaryTextLabel)

        setupLayout()
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        diaryHeaderView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(78)
        }

        diaryImageView.snp.makeConstraints { make in
            make.top.equalTo(diaryHeaderView.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(306)
        }

        diaryDrawingView.snp.makeConstraints { make in
            make.top.equalTo(diaryImageView.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().offset(-20)
        }

        diaryTextLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(27)
        }
    }

    // MARK: - Public Methods

    func configureDiaryImage(with image: UIImage?) {
        diaryImageView.image = image
    }

    func configureReplyText(with text: String) {
        diaryTextLabel.text = text
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
