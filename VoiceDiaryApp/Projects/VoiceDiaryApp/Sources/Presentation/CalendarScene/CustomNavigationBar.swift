//
//  CustomNavigationBar.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit

import SnapKit
import Combine

final class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    var setTitleLabel: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var isExitButtonIncluded: Bool {
        get { !exitButton.isHidden }
        set { exitButton.isHidden = !newValue }
    }
    
    var isLetterButtonIncluded: Bool {
        get { !letterButton.isHidden }
        set { letterButton.isHidden = !newValue }
    }
    
    var isSaveButtonIncluded: Bool {
        get { !saveButton.isHidden }
        set { saveButton.isHidden = !newValue }
    }
    
    var backButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnBack), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnExit), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = .fontGuide(type: .PretandardSemiBold, size: 20)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        return label
    }()
    
    private let letterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnLetter), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnSave), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomNavigationBar {
    
    func setUI() {
        self.backgroundColor = .clear
    }
    
    func setHierarchy() {
        addSubviews(backButton,
                    exitButton,
                    titleLabel,
                    letterButton,
                    saveButton)
    }
    
    func setLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        letterButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26)
            make.centerY.equalToSuperview()
            make.size.equalTo(31)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26)
            make.centerY.equalToSuperview()
            make.size.equalTo(31)
        }
    }
    
    func setButton() {
        backButton.tapPublisher
            .sink(receiveValue: {
                self.backButtonAction?()
            })
            .store(in: &cancellables)
    }
}
