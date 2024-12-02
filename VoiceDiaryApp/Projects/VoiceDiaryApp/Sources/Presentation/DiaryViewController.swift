//
//  DiaryViewController.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import Combine

class DiaryViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: DiaryViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    private let diaryView = DiaryView()

    // MARK: - Initializers
    init(viewModel: DiaryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        configureCalendarView()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = UIColor(named: "mainBeige")
        view.addSubview(diaryView)
        diaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        diaryView.navigationBar.setTitle("캘린더")
    }

    private func bindViewModel() {
        viewModel.diaryEntriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.diaryView.calendarView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.selectedEntryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedEntry in
                self?.updateDiaryView(for: selectedEntry)
            }
            .store(in: &cancellables)
    }

    private func configureCalendarView() {
        diaryView.calendarView.register(DiaryEntryCell.self, forCellWithReuseIdentifier: "DiaryEntryCell")
        diaryView.calendarView.delegate = self
        diaryView.calendarView.dataSource = self
    }

    // MARK: - Update Methods
    private func updateDiaryView(for entry: DiaryEntry?) {
        if let entry = entry {
            diaryView.emotionImageView.image = UIImage(named: entry.emotion.rawValue)
            diaryView.diaryTextView.text = entry.content
        } else {
            diaryView.emotionImageView.image = nil
            diaryView.diaryTextView.text = "선택된 다이어리가 없습니다."
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DiaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.diaryEntries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryEntryCell", for: indexPath) as! DiaryEntryCell
        let entry = viewModel.diaryEntries[indexPath.row]
        cell.configure(with: entry)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = viewModel.diaryEntries[indexPath.row].date
        viewModel.fetchDiary(for: selectedDate)
    }
}
