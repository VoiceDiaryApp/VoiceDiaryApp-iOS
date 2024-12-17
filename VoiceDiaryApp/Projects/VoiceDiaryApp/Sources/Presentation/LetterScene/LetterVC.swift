//
//  LetterVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/17/24.
//


import UIKit

import SnapKit

final class LetterVC: UIViewController {
    
    // MARK: - UI Components
    
    private let navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.isBackButtonIncluded = false
        navigationBar.isExitButtonIncluded = true
        navigationBar.isSaveButtonIncluded = true
        navigationBar.setTitleLabel = "깨비의 답장"
        return navigationBar
    }()
    
    private let characterImageView = UIImageView(image: UIImage(resource: .imgLetterCharacter))
    
    private let letterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.text = "편지내용\n편지지지지지지지지지\n어쩌구저쩌구루루ㅜ루루루루룰"
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardMedium, size: 17)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
}

private extension LetterVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        navigationBar.exitButtonAction = {
            print("tapExitButton")
        }
        
        navigationBar.saveButtonAction = {
            print("tapSaveButton")
        }
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         characterImageView,
                         letterView)
        letterView.addSubview(letterLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.calSupporHeight(height: 55))
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(209)
            $0.height.equalTo(158)
        }
        
        letterView.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 71)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-19)
        }
        
        letterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(41)
            $0.leading.trailing.equalToSuperview().inset(33)
        }
    }
}
