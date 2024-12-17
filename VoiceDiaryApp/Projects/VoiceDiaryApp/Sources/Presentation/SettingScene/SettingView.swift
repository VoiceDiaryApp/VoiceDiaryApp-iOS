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
        addSubview(navigationBar)
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
    }
}
