//
//  LoadingVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/17/24.
//

import UIKit

import SnapKit

final class LoadingVC: UIViewController {
    
    // MARK: - Properties
    
    private let diaryVM: DiaryVM
    
    // MARK: - UI Components
    
    private let loadingImageView = UIImageView(image: UIImage(resource: .imgLoading))
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "똑깨비가 답장을 쓰고 있어요\n잠시 기다려주세요"
        label.textColor = UIColor(resource: .calendarSelected)
        label.font = .fontGuide(type: .PretandardSemiBold, size: 18)
        label.numberOfLines = 0
        label.asLineHeight(25)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: DiaryVM) {
        self.diaryVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showNextPage()
        }
    }
}

private extension LoadingVC {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(resource: .mainBeige)
        loadingImageView.contentMode = .scaleAspectFit
    }
    
    func setHierarchy() {
        view.addSubviews(loadingImageView,
                         loadingLabel)
    }
    
    func setLayout() {
        loadingImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(SizeLiterals.calSupporHeight(height: 250))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(DeviceUtils.isIPad() ? 562 : 219)
            $0.height.equalTo(DeviceUtils.isIPad() ? 328 : 128)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.top.equalTo(loadingImageView.snp.bottom).offset(31)
            $0.centerX.equalToSuperview()
        }
    }
    
    func showNextPage() {
        let letterVC = LetterVC(viewModel: diaryVM, selectedDate: diaryVM.selectedDate, isFromCalendar: false)
        letterVC.modalPresentationStyle = .overFullScreen
        self.present(letterVC, animated: true)
    }
}
