//
//  Diary2View.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

final class Diary2View: UIView {
    
    // MARK: - UI Components
    
    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
//        navBar.setTitle("일기 쓰기")
        return navBar
    }()
    
    private let todayMoodLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 기분"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        label.textColor = UIColor(hex: "#000000")
        return label
    }()
    
    private let moodEmojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let drawingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FFDF7E")
        button.layer.cornerRadius = 8
        button.setTitle("기록하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIColor(named: "mainBeige")
    }
    
    private func setupHierarchy() {
        addSubviews(navigationBar, todayMoodLabel, moodEmojiView, drawingView, saveButton)
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        todayMoodLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(28)
        }
        
        moodEmojiView.snp.makeConstraints { make in
            make.top.equalTo(todayMoodLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(46)
        }
        
        drawingView.snp.makeConstraints { make in
            make.top.equalTo(moodEmojiView.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(saveButton.snp.top).offset(-24)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(44)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.height.equalTo(57)
        }
    }
}
