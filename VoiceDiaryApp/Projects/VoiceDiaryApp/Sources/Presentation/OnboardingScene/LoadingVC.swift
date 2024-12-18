//
//  LoadingVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/17/24.
//

import UIKit

import SnapKit

final class LoadingVC: UIViewController {
    
    // MARK: - UI Components
    
    private let loadingImageView = UIImageView(image: UIImage(resource: .imgLoading))
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "요정이가 답장을 쓰고 있어요\n잠시 기다려주세요"
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardSemiBold, size: 18)
        label.numberOfLines = 0
        label.asLineHeight(25)
        label.textAlignment = .center
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

private extension LoadingVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(resource: .mainBeige)
    }
    
    func setHierarchy() {
        view.addSubviews(loadingImageView,
                         loadingLabel)
    }
    
    func setLayout() {
        loadingImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(SizeLiterals.calSupporHeight(height: 250))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.calSupporWidth(width: 219))
            $0.height.equalTo(SizeLiterals.calSupporHeight(height: 128))
        }
        
        loadingLabel.snp.makeConstraints {
            $0.top.equalTo(loadingImageView.snp.bottom).offset(31)
            $0.centerX.equalToSuperview()
        }
    }
    
    func showNextPage() {
//        let letterVC = LetterVC()
//        self.navigationController?.pushViewController(letterVC, animated: true)
    }
}
