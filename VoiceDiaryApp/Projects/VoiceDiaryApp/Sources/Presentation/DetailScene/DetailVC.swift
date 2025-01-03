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

        detailView.configureDiaryImage(with: UIImage(named: diaryEntry.drawImage))
        detailView.configureReplyText(with: diaryEntry.content)
    }

    // MARK: - Navigation
    private func navigateToLetterVC() {
        let diaryVM = DiaryVM()
        let letterVC = LetterVC(viewModel: diaryVM)
        navigationController?.pushViewController(letterVC, animated: true)
    }
}
