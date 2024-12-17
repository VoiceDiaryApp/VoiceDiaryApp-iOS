//
//  SplashVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/16/24.
//

import UIKit

import SnapKit

final class SplashVC: UIViewController {
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView(image: UIImage(resource: .imgLogo))
    
    private let logoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 이름"
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardMedium, size: 18)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showNextPage()
        }
    }
}

private extension SplashVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    func setHierarchy() {
        view.addSubviews(logoImageView,
                         logoTitleLabel)
    }
    
    func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(SizeLiterals.calSupporHeight(height: 300))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(SizeLiterals.calSupporWidth(width: 90))
        }
        
        logoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
    }
    
    func showNextPage() {
        let homeVC = HomeVC()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
