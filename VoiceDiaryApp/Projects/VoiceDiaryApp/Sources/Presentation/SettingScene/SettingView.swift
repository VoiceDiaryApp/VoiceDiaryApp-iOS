//
//  SettingView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit
import Combine

class SettingView: UIView {
    // MARK: - Combine
    let alertTogglePublisher = PassthroughSubject<Bool, Never>()
    let alertChangePublisher = PassthroughSubject<Void, Never>()
    let deleteActionPublisher = PassthroughSubject<Void, Never>()

    // MARK: - UI Elements
    private let navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.setTitleLabel = "설정"
        return navigationBar
    }()
    
    private let alertView = UIView()
    private let alertTitle: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private let alertDescriptionText: UILabel = {
        let label = UILabel()
        label.text = "처음에 정한 시간에 알람을 보내드려요."
        label.font = .fontGuide(type: .PretandardMedium, size: 13)
        label.textColor = UIColor(resource: .calendarTextBlack)
        return label
    }()
    
    private let alertToggle: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()
    
    private let alertChangeView = UIView()
    private let alertChangeTitle: UILabel = {
        let label = UILabel()
        label.text = "알림 시간 변경"
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private let alertChangeDescriptionText: UILabel = {
        let label = UILabel()
        label.text = "알림 시간을 변경할 수 있어요."
        label.font = .fontGuide(type: .PretandardMedium, size: 13)
        label.textColor = UIColor(resource: .calendarTextBlack)
        return label
    }()
    
    private let deleteView = UIView()
    private let deleteTitle: UILabel = {
        let label = UILabel()
        label.text = "모든 기록 삭제"
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private let deleteDescriptionText: UILabel = {
        let label = UILabel()
        label.text = "삭제된 내용은 복구할 수 없어요."
        label.font = .fontGuide(type: .PretandardMedium, size: 13)
        label.textColor = UIColor(resource: .calendarTextBlack)
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupHierarchy()
        setupLayout()
        setupInteractions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor(resource: .mainBeige)
    }
    
    private func setupHierarchy() {
        addSubviews(navigationBar, alertView, alertChangeView, deleteView)
        alertView.addSubviews(alertTitle, alertDescriptionText, alertToggle)
        alertChangeView.addSubviews(alertChangeTitle, alertChangeDescriptionText)
        deleteView.addSubviews(deleteTitle, deleteDescriptionText)
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        alertView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(33)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(50)
        }
        
        alertTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        alertDescriptionText.snp.makeConstraints { make in
            make.top.equalTo(alertTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        alertToggle.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
        
        alertChangeView.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(50)
        }
        
        alertChangeTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        alertChangeDescriptionText.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
        }
        
        deleteView.snp.makeConstraints { make in
            make.top.equalTo(alertChangeView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(50)
        }
        
        deleteTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        deleteDescriptionText.snp.makeConstraints { make in
            make.top.equalTo(deleteTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
    }
    
    private func setupInteractions() {
        alertToggle.addTarget(self, action: #selector(alertToggleChanged(_:)), for: .valueChanged)
        
        let alertChangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(alertChangeTapped))
        alertChangeView.addGestureRecognizer(alertChangeTapGesture)
        
        let deleteViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteViewTapped))
        deleteView.addGestureRecognizer(deleteViewTapGesture)
    }
    
    // MARK: - Actions
    @objc private func alertToggleChanged(_ sender: UISwitch) {
        alertTogglePublisher.send(sender.isOn)
    }
    
    @objc private func alertChangeTapped() {
        alertChangePublisher.send(())
    }
    
    @objc private func deleteViewTapped() {
        deleteActionPublisher.send(())
    }
    
    // MARK: - Public Methods
    func setNavigationBarBackAction(_ action: @escaping () -> Void) {
        navigationBar.backButtonAction = action
    }
}
