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

    private let diaryContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(resource: .calendarSelected).cgColor
        view.layer.borderWidth = 2
        return view
    }()

    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .fontGuide(type: .PretandardRegular, size: 13)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textAlignment = .left
        textView.text = "일기 내용이 여기에 표시됩니다.\n답장 레이블 높이는 내용에 따라 조정됩니다."
        textView.backgroundColor = .clear
        return textView
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
        addSubviews(navigationBar, diaryHeaderView, diaryImageView, diaryContentView)
        diaryContentView.addSubview(diaryTextView)

        setupLayout()
    }

    private func setupLayout() {

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        diaryHeaderView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        diaryImageView.snp.makeConstraints { make in
            make.top.equalTo(diaryHeaderView.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(306)
        }

        diaryContentView.snp.makeConstraints { make in
            make.top.equalTo(diaryImageView.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
        }

        diaryTextView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(27)
        }
    }

    // MARK: - Public Methods

    func configureDiaryImage(with image: UIImage?) {
        diaryImageView.image = image
    }

    func configureReplyText(with text: String) {
        diaryTextView.text = text
    }
}

final class DiaryHeaderView: UIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontGuide(type: .PretandardSemiBold, size: 20)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontGuide(type: .PretandardSemiBold, size: 17)
        label.textColor = UIColor(resource: .calendarTextBlack)
        label.numberOfLines = 1
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .clear
        addSubviews(titleLabel, dateLabel, emojiView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(31)
            make.trailing.equalTo(emojiView.snp.leading).offset(-8)
            make.height.lessThanOrEqualTo(50)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.height.lessThanOrEqualTo(25)
        }

        emojiView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(39)
            make.size.equalTo(46)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(dateLabel.snp.bottom)
        }
    }

    // MARK: - Configuration

    func configure(title: String, date: String, emotion: Emotion) {
        titleLabel.text = title
        dateLabel.text = date
        emojiView.image = UIImage(named: emotion.rawValue)
    }
}
