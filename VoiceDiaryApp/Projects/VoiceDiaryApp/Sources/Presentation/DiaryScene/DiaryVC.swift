//
//  DiaryVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/3/24.
//

import UIKit

import SnapKit
import Combine
import Speech
import Accelerate

final class DiaryVC: UIViewController {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let microphoneStartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnMicrophoneStart), for: .normal)
        return button
    }()
    
    private let microphoneEndButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnMicrophoneEnd), for: .normal)
        return button
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = "버튼을 누르고 말해보세요!"
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private var microphoneLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .fontGuide(type: .PretandardMedium, size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
}

private extension DiaryVC {
    
    func setUI() {
        view.backgroundColor  = .white
        
    }
    
    func setHierarchy() {
        view.addSubviews(microphoneLabel,
                         microphoneStartButton,
                         explainLabel)
    }
    
    func setLayout() {
        microphoneLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        explainLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-117)
            $0.centerX.equalToSuperview()
        }
        
        microphoneStartButton.snp.makeConstraints {
            $0.bottom.equalTo(explainLabel.snp.top)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(104)
        }
    }
    
    func setDelegate() {
       
    }
    
}
