//
//  CustomAlertView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import UIKit
import SnapKit

class CustomAlertView: UIView {
    // MARK: - Properties
    var onCancel: (() -> Void)?
    var onDelete: (() -> Void)?
    
    // MARK: - UI Elements
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 모든 기록을 삭제하시겠습니까?"
        label.font = .fontGuide(type: .PretandardBold, size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이 작업은 되돌릴 수 없습니다.\n삭제를 진행하시겠습니까?"
        label.font = .fontGuide(type: .PretandardSemiBold, size: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 15)
        button.backgroundColor = UIColor(resource: .mainYellow)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 15)
        button.backgroundColor = UIColor(resource: .mainYellow)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubviews(dimView,
                   alertView)
        alertView.addSubviews(titleLabel,
                             descriptionLabel,
                              cancelButton,
                              deleteButton)
    }
    
    private func setupLayout() {
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(SizeLiterals.Screen.screenWidth - 74)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(SizeLiterals.calSupporHeight(height: 25))
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo((SizeLiterals.Screen.screenWidth - 156) / 2)
            make.height.equalTo(SizeLiterals.calSupporHeight(height: 40))
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(30)
            make.width.equalTo((SizeLiterals.Screen.screenWidth - 156) / 2)
            make.height.equalTo(SizeLiterals.calSupporHeight(height: 40))
        }
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        let dimViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        dimView.addGestureRecognizer(dimViewTapGesture)
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        onCancel?()
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}
