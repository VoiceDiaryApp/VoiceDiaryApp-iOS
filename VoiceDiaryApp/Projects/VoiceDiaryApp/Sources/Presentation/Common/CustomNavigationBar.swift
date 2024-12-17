//
//  CustomNavigationBar.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

final class CustomNavigationBar: UIView {

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton.svg"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        return label
    }()

    private let rightIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rightIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Add subviews
        addSubviews(backButton, titleLabel, rightIcon)

        // Back Button Constraints
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Right Icon Constraints
        rightIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-26)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(31)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
