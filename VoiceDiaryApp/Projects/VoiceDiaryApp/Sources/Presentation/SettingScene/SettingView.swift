//
//  SettingView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

class SettingView: UIView {
    
    // MARK: - UI Elements
    private let navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.setTitleLabel = "설정"
        return navigationBar
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        label.textColor = UIColor(hex: "6B6B6B", alpha: 1)
        return label
    }()
    
    private let alertToggle: UISwitch = {
        let switchButton = UISwitch()
        return switchButton
    }()
    
    private let deleteView: UIView = {
       let view = UIView()
        return view
    }()
    
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
        label.textColor = UIColor(hex: "6B6B6B", alpha: 1)
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor(resource: .mainBeige)
    }
    
    private func setupHierarchy() {
        addSubviews(navigationBar, alertView, deleteView)
        alertView.addSubviews(alertTitle, alertDescriptionText, alertToggle)
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
            make.height.equalTo(55)
        }
        
        alertTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        alertDescriptionText.snp.makeConstraints{ make in
            make.top.equalTo(alertTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        alertToggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        deleteView.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(53)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(50)
        }
        
        deleteTitle.snp.makeConstraints{ make in
            make.top.leading.equalToSuperview()
        }
        
        deleteDescriptionText.snp.makeConstraints { make in
            make.top.equalTo(deleteTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    func setNavigationBarBackAction(_ action: @escaping () -> Void) {
        navigationBar.backButtonAction = action
    }
}
