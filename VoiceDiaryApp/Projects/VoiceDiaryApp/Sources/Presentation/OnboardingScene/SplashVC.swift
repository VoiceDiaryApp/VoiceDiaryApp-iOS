//
//  SplashVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/16/24.
//

import UIKit

import SnapKit
import RealmSwift

final class SplashVC: UIViewController {
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView(image: UIImage(resource: .imgLogo))
    
    private let logoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "똑깨비"
        label.textColor = .black
        label.font = .fontGuide(type: .GangwonEduSaeeum, size: DeviceUtils.isIPad() ? 50 : 30)
        label.setOutline(outlineColor: .black, outlineWidth: 1.5)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        printRealmFilePath()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showNextPage()
        }
    }
}

private extension SplashVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(resource: .mainBeige)
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
        let isNotificationSet = UserManager.shared.getSetNotification
        
        if isNotificationSet {
            let homeVC = HomeVC()
            self.navigationController?.pushViewController(homeVC, animated: true)
        } else {
            let onboardingVC = OnboardingVC()
            self.navigationController?.pushViewController(onboardingVC, animated: true)
        }
    }
    
    private func printRealmFilePath() {
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm 파일 경로: \(fileURL.path)")
        } else {
            print("Realm 파일 경로를 찾을 수 없습니다.")
        }
    }
}
