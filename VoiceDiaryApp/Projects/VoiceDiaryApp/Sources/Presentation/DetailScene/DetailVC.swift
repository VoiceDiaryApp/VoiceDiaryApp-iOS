//
//  DetailVC.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/18/24.
//

import UIKit
import Combine

final class DetailVC: UIViewController {

    // MARK: - Properties

    private let detailView = DetailView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: CalendarVMProtocol
    private let selectedDate: Date

    // MARK: - Initializers

    init(viewModel: CalendarVMProtocol, selectedDate: Date) {
        self.viewModel = viewModel
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
        viewModel.fetchDiary(for: selectedDate)
    }

    // MARK: - Setup

    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        detailView.navigationBar.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupActions() {
        detailView.navigationBar.letterButtonAction = { [weak self] in
            guard let self = self else { return }
            let diaryVM = DiaryVM()
            let letterVC = LetterVC(viewModel: diaryVM, selectedDate: self.selectedDate, isFromCalendar: true)
            self.navigationController?.pushViewController(letterVC, animated: true)
        }
    }

    private func bindViewModel() {
        guard let diaryEntry = viewModel.diaryEntries.first else { return }

        guard let diaryDate = diaryEntry.date.toDate() else {
            print("Invalid date format in diaryEntry.date: \(diaryEntry.date)")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        let dateString = dateFormatter.string(from: diaryDate)

        detailView.diaryHeaderView.configure(
            title: diaryEntry.title,
            date: dateString,
            emotion: diaryEntry.emotion
        )
        
        if diaryEntry.drawImage.isEmpty {
            detailView.emptyDiaryCharacter.isHidden = false
        } else {
            detailView.emptyDiaryCharacter.isHidden = true

            let fileManager = FileManager.default
            let imagePath = diaryEntry.drawImage
            let fileName = (imagePath as NSString).lastPathComponent
            
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let imagePath = documentsDirectory.appendingPathComponent(fileName).path
                if fileManager.fileExists(atPath: imagePath) {
                    if let image = UIImage(contentsOfFile: imagePath) {
                        detailView.configureDiaryImage(with: image)
                    } else {
                        print("이미지 로드 실패")
                    }
                } else {
                    print("파일이 존재하지 않습니다.")
                }
            }
        }
        detailView.configureReplyText(with: diaryEntry.content)
    }

    // MARK: - Navigation
    private func navigateToLetterVC() {
        let diaryVM = DiaryVM()
        let letterVC = LetterVC(viewModel: diaryVM)
        navigationController?.pushViewController(letterVC, animated: true)
    }
}
