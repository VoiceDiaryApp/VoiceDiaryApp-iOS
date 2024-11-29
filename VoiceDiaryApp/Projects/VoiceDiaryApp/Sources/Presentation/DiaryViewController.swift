//
//  DiaryViewController.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import Combine
import SnapKit

class DiaryViewController: UIViewController {
    
    private var viewModel: DiaryViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emotionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(viewModel: DiaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impolemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.$diaryEntries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        viewModel.fetchDiary(for: Date())
    }
    
    private func setupUI() {
        view.addSubview(calendarView)
        view.addSubview(emotionImageView)
        view.addSubview(diaryTextView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(300)
        }
        
        emotionImageView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.width.equalTo(100)
        }
        
        diaryTextView.snp.makeConstraints { make in
            make.top.equalTo(emotionImageView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func updateUI() {
        guard let selectedEntry = viewModel.selectedEntry else { return }
        emotionImageView.image = UIImage(named: selectedEntry.emotion.rawValue)
        diaryTextView.text = selectedEntry.content
    }
}

extension DiaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.diaryEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = viewModel.diaryEntries[indexPath.row].date
        viewModel.fetchDiary(for: selectedDate)
    }
}
