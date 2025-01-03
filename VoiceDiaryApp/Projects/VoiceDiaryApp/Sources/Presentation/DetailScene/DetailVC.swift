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

    // MARK: - Initializers

    init(viewModel: CalendarVMProtocol) {
        self.viewModel = viewModel
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
    }

    // MARK: - Setup

    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupActions() {
        detailView.navigationBar.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        detailView.navigationBar.letterButtonAction = { [weak self] in
            self?.navigateToLetterVC()
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
