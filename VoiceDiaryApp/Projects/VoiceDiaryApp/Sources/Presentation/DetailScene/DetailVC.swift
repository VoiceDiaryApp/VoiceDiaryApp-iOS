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
        setupBindings()
        setupActions()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .mainBeige)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Bindings & Actions

    private func setupBindings() {
    }

    private func setupActions() {
        detailView.navigationBar.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        detailView.navigationBar.letterButtonAction = { [weak self] in
            self?.navigateToLetterVC()
        }
    }

    // MARK: - Navigation

    private func navigateToLetterVC() {
        let letterVC = LetterVC()
        navigationController?.pushViewController(letterVC, animated: true)
    }
}
