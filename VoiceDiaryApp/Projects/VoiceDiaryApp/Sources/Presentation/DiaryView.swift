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
    let navigationBar = CustomNavigationBar()

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

    private(set) var calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private(set) var emotionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        return textView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setDateLabels(year: Calendar.current.component(.year, from: Date()),
                      month: Calendar.current.component(.month, from: Date()))
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
        addSubview(calendarView)
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

        // 캘린더 뷰 레이아웃
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(309)
            make.bottom.lessThanOrEqualTo(emotionImageView.snp.top).offset(-20)
        }

        // 감정 이미지 뷰 레이아웃
        emotionImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(calendarView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }

        // 다이어리 텍스트 뷰 레이아웃
        diaryTextView.snp.makeConstraints { make in
            make.top.equalTo(emotionImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    // MARK: - Public Methods
    func setDateLabels(year: Int, month: Int) {
        yearLabel.text = "\(year)년"
        monthLabel.text = "\(month)월"
    }
}
