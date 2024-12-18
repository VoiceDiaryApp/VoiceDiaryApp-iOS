//
//  DetailView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/18/24.
//

import UIKit
import SnapKit

final class DetailView: UIView {

    // MARK: - Properties

    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitleLabel = "나의 일기장"
        navBar.isBackButtonIncluded = true
        navBar.isLetterButtonIncluded = true
        return navBar
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setUI() {
        backgroundColor = .white
    }

    private func setHierarchy() {
        addSubview(navigationBar)
    }

    private func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
