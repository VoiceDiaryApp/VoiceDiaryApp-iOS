//
//  DiaryViewController.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import Combine

class DiaryViewController: UIViewController {

    private var viewModel: DiaryViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    private let diaryView = DiaryView()

    init(viewModel: DiaryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        diaryView.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "mainBeige")
        view.addSubview(diaryView)
        diaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.diaryEntriesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] entries in
                self?.diaryView.calendarView.updateDiaryEntries(entries)
            }
            .store(in: &cancellables)
    }
}
