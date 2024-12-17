//
//  Diary2View.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

final class Diary2View: UIView {
    
    // MARK: - Properties
    private var selectedEmotion: Emotion?
    
    private let emotions: [Emotion] = [
        .angry, .happy, .neutral, .sad, .smiling, .tired
    ]
    
    private var emotionButtons: [UIButton] = []
    
    // MARK: - UI Components
    
    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitle("일기 쓰기")
        return navBar
    }()
    
    private let moodEmojiView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let drawingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("기록하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(hex: "#FFDF7E")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupHierarchy()
        setupLayout()
        setupEmotionButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIColor(resource: .mainBeige)
    }
    
    private func setupHierarchy() {
        addSubviews(navigationBar, moodEmojiView, drawingView, saveButton)
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        moodEmojiView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(19)
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
    
    // MARK: - Emotion Buttons Setup
    
    private func setupEmotionButtons() {
        emotions.forEach { emotion in
            let button = UIButton()
            button.setImage(UIImage(named: emotion.rawValue), for: .normal)
            button.contentMode = .scaleAspectFit
            button.tag = emotions.firstIndex(of: emotion) ?? 0
            button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
            moodEmojiView.addArrangedSubview(button)
            emotionButtons.append(button)
        }
    }
    
    @objc private func emotionButtonTapped(_ sender: UIButton) {
        let tappedEmotion = emotions[sender.tag]
        updateSelectedEmotion(to: tappedEmotion)
    }
    
    private func updateSelectedEmotion(to newEmotion: Emotion) {
        selectedEmotion = newEmotion
        
        for (index, button) in emotionButtons.enumerated() {
            let emotion = emotions[index]
            let imageName = (emotion == newEmotion) ? "\(emotion.rawValue)_stroke" : emotion.rawValue
            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }
}
