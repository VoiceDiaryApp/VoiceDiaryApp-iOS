//
//  DiaryView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class DiaryView: UIView {

    // MARK: - UI Components
    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitle("캘린더")
        return navBar
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        label.textAlignment = .center
        return label
    }()

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()

    private(set) var emotionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        textView.textAlignment = .natural
        return textView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDateLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = UIColor(named: "mainBeige")

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        addSubview(navigationBar)
        addSubview(yearLabel)
        addSubview(monthLabel)
        addSubview(emotionImageView)
        addSubview(diaryTextView)
    }

    private func setupConstraints() {
        // 네비게이션 바 레이아웃
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }

        // 연도 레이아웃
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }

        // 월 레이아웃
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

    }

    // MARK: - Public Methods
    func configureDateLabels(year: Int = Calendar.current.component(.year, from: Date()),
                             month: Int = Calendar.current.component(.month, from: Date())) {
        yearLabel.text = "\(year)년"
        monthLabel.text = "\(month)월"
    }

    func updateEmotionImageView(with imageName: String?) {
        if let name = imageName, let image = UIImage(named: name) {
            emotionImageView.image = image
        } else {
            emotionImageView.image = UIImage(named: "defaultEmotion")
        }
    }

    func updateDiaryTextView(with text: String?) {
        diaryTextView.text = text ?? "선택된 다이어리가 없습니다."
    }
}
