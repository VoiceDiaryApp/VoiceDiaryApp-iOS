//
//  CalendarVC.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import Combine

final class CalendarVC: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties

    private let viewModel: CalendarVMProtocol
    private var cancellables = Set<AnyCancellable>()

    private lazy var diaryView: DiaryView = {
        let view = DiaryView(viewModel: viewModel)
        return view
    }()

    // MARK: - Initializer

    init(viewModel: CalendarVMProtocol = CalendarVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .mainBeige)

        diaryView.navigationBar.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

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
