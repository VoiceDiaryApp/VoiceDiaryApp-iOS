//
//  DiaryView.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/2/24.
//

import UIKit
import SnapKit

class DiaryView: UIView, CalendarViewDelegate {

    var viewModel: DiaryViewModelProtocol!
    var selectedDate: Date?

    let navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.setTitle("캘린더")
        return navBar
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CalendarTextBlack")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        label.textAlignment = .center
        return label
    }()

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CalendarTextBlack")
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()

    private let leftArrowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "CalendarTextBlack")
        button.transform = CGAffineTransform(rotationAngle: .pi)
        return button
    }()

    private let rightArrowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "CalendarTextBlack")
        return button
    }()

    let calendarView: CalendarView = CalendarView()

    private let diaryContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()

    private let diaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Diary Title"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        label.attributedText = NSMutableAttributedString(
            string: "일기 제목",
            attributes: [
                .kern: -0.5,
                .paragraphStyle: paragraphStyle,
            ])
        return label
    }()

    private let diaryDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "CalendarTextBlack")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        label.attributedText = NSMutableAttributedString(
            string: "11월 19일",
            attributes: [
                .kern: -0.5,
                .paragraphStyle: paragraphStyle,
            ])
        return label
    }()

    private let diaryContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Diary Content"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .justified
        return label
    }()

    private let moreLabel: UILabel = {
        let label = UILabel()
        label.text = "더보기"
        label.textColor = UIColor(named: "CalendarSelected")
        label.font = UIFont(name: "Pretendard-Regular", size: 11)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(
            string: "더보기",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        return label
    }()

    private let emptyDiaryCharacter: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyDiaryCharacter")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emptyDiaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "CalendarSelected")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 17)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.99
        label.attributedText = NSMutableAttributedString(
            string: "일기가 비어있어요.",
            attributes: [
                .kern: -0.5,
                .paragraphStyle: paragraphStyle,
            ]
        )
        label.textAlignment = .center
        return label
    }()

    private var currentDate: Date = Date()

    init(viewModel: DiaryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        configureDateLabels()
        setupActions()
        setupDiaryContentView()

        selectedDate = currentDate
        calendarView.delegate = self

        let hasDiary = checkIfDiaryExists(for: selectedDate!)
        updateDiaryContentView(for: selectedDate!, hasDiary: hasDiary)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "mainBeige")

        addSubview(navigationBar)
        addSubview(yearLabel)
        addSubview(monthLabel)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(calendarView)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        leftArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel.snp.centerY).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.width.height.equalTo(24)
        }

        rightArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel.snp.centerY).offset(10)
            make.trailing.equalToSuperview().offset(-28)
            make.width.height.equalTo(24)
        }

        calendarView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureDateLabels() {
        let calendar = Calendar.current
        let targetDate = selectedDate ?? currentDate
        yearLabel.text = "\(calendar.component(.year, from: currentDate))년"
        monthLabel.text = "\(calendar.component(.month, from: currentDate))월"
        updateDiaryDateLabel(for: targetDate)
    }

    private func setupActions() {
        leftArrowButton.addTarget(
            self, action: #selector(didTapLeftArrow), for: .touchUpInside)
        rightArrowButton.addTarget(
            self, action: #selector(didTapRightArrow), for: .touchUpInside)
    }

    @objc private func didTapLeftArrow() {
        animateCalendarTransition(byAddingMonths: -1, direction: .fromLeft)
    }

    @objc private func didTapRightArrow() {
        animateCalendarTransition(byAddingMonths: 1, direction: .fromRight)
    }

    private func animateCalendarTransition(
        byAddingMonths months: Int,
        direction: CATransitionSubtype
    ) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: months, to: currentDate) {
            currentDate = newDate

            let transition = CATransition()
            transition.type = .push
            transition.subtype = direction
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            calendarView.layer.add(transition, forKey: kCATransition)
            calendarView.updateMonth(date: currentDate)
            configureDateLabels()
        }
    }

    func calendarViewDidUpdateDate(_ calendarView: CalendarView, to date: Date) {
        selectedDate = date
        let hasDiary = checkIfDiaryExists(for: selectedDate!)
        updateDiaryContentView(for: selectedDate!, hasDiary: hasDiary)
        configureDateLabels()
    }

    private func setupDiaryContentView() {
        addSubview(diaryContentView)
        diaryContentView.addSubview(diaryTitleLabel)
        diaryContentView.addSubview(diaryDateLabel)
        diaryContentView.addSubview(diaryContentLabel)
        diaryContentView.addSubview(moreLabel)

        diaryContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(174)
            make.bottom.equalToSuperview()
        }

        diaryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryContentView.snp.top).offset(22)
            make.leading.equalTo(diaryContentView.snp.leading).offset(37)
        }

        diaryDateLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(diaryTitleLabel.snp.leading)
        }

        diaryContentLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryDateLabel.snp.bottom).offset(13)
            make.leading.equalTo(diaryContentView.snp.leading).offset(36)
            make.trailing.equalTo(diaryContentView.snp.trailing).offset(-36)
        }

        moreLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryContentView.snp.top).offset(22)
            make.trailing.equalTo(diaryContentView.snp.trailing).offset(-32)
        }
    }

    private func updateDiaryDateLabel(for date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        let formattedDate = formatter.string(from: date)
        diaryDateLabel.text = formattedDate
    }

    private func updateDiaryContentView(for date: Date, hasDiary: Bool) {
        guard let diaryEntries = viewModel?.diaryEntries else {
            showEmptyDiaryView(isFutureDate: Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending)
            return
        }
        
        if hasDiary {
            diaryTitleLabel.isHidden = false
            diaryDateLabel.isHidden = false
            diaryContentLabel.isHidden = false
            emptyDiaryCharacter.isHidden = true
            emptyDiaryLabel.isHidden = true
            
            diaryTitleLabel.text = "일기 제목"
            updateDiaryDateLabel(for: date)
            
            if let diaryEntry = diaryEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                diaryContentLabel.attributedText = processContentText(diaryEntry.content)
            } else {
                diaryContentLabel.attributedText = processContentText("일기 내용 일부를 여기에 표시합니다.")
            }
            
            moreLabel.isHidden = false
            moreLabel.text = "더보기"
        } else {
            showEmptyDiaryView(isFutureDate: Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending)
        }
    }
    
    private func showEmptyDiaryView(isFutureDate: Bool) {
        diaryTitleLabel.isHidden = true
        diaryDateLabel.isHidden = true
        diaryContentLabel.isHidden = true

        emptyDiaryCharacter.isHidden = false
        emptyDiaryLabel.isHidden = false

        if isFutureDate {
            moreLabel.isHidden = true
        } else {
            moreLabel.isHidden = false
            moreLabel.text = "일기 쓰러 가기"
        }

        if emptyDiaryCharacter.superview == nil {
            diaryContentView.addSubview(emptyDiaryCharacter)
            emptyDiaryCharacter.snp.makeConstraints { make in
                make.centerX.equalTo(diaryContentView)
                make.top.equalTo(diaryContentView.snp.top).offset(45)
                make.width.equalTo(66.5)
                make.height.equalTo(62.7)
            }
        }

        if emptyDiaryLabel.superview == nil {
            diaryContentView.addSubview(emptyDiaryLabel)
            emptyDiaryLabel.snp.makeConstraints { make in
                make.centerX.equalTo(diaryContentView)
                make.top.equalTo(emptyDiaryCharacter.snp.bottom).offset(15.25)
            }
        }
    }
    
    private func updateDiaryUI(for date: Date, hasDiary: Bool) {
        if hasDiary {
            diaryTitleLabel.isHidden = false
            diaryDateLabel.isHidden = false
            diaryContentLabel.isHidden = false
            emptyDiaryCharacter.isHidden = true
            emptyDiaryLabel.isHidden = true

            diaryTitleLabel.text = "일기 제목"
            updateDiaryDateLabel(for: date)
            diaryContentLabel.text =
                viewModel.diaryEntries
                .first { Calendar.current.isDate($0.date, inSameDayAs: date) }?
                .content ?? "일기 내용 일부를 여기에 표시합니다."
        } else {
            showEmptyDiaryView()
        }
    }

    private func showEmptyDiaryView() {
        diaryTitleLabel.isHidden = true
        diaryDateLabel.isHidden = true
        diaryContentLabel.isHidden = true

        emptyDiaryCharacter.isHidden = false
        emptyDiaryLabel.isHidden = false
        moreLabel.text = "일기 쓰러 가기"

        if emptyDiaryCharacter.superview == nil {
            diaryContentView.addSubview(emptyDiaryCharacter)
            emptyDiaryCharacter.snp.makeConstraints { make in
                make.centerX.equalTo(diaryContentView)
                make.top.equalTo(diaryContentView.snp.top).offset(45)
                make.width.equalTo(66.5)
                make.height.equalTo(62.7)
            }
        }

        if emptyDiaryLabel.superview == nil {
            diaryContentView.addSubview(emptyDiaryLabel)
            emptyDiaryLabel.snp.makeConstraints { make in
                make.centerX.equalTo(diaryContentView)
                make.top.equalTo(emptyDiaryCharacter.snp.bottom).offset(15.25)
            }
        }
    }

    private func checkIfDiaryExists(for date: Date) -> Bool {
        guard let diaryEntries = viewModel?.diaryEntries else {
            return false
        }
        return diaryEntries.contains {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    private func processContentText(_ text: String) -> NSAttributedString {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = trimmedText.first == " " ? String(trimmedText.dropFirst()) : trimmedText

        let font = UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let labelWidth = UIScreen.main.bounds.width - 72
        let maxLines = 3
        let lineSpacing: CGFloat = 2.0

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = lineSpacing

        let fullAttributedText = NSMutableAttributedString(
            string: content,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]
        )

        let lineHeight = font.lineHeight + lineSpacing
        let maxHeight = lineHeight * CGFloat(maxLines)

        let boundingRect = fullAttributedText.boundingRect(
            with: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        if boundingRect.height <= maxHeight {
            return fullAttributedText
        }

        var truncatedText = content
        while truncatedText.count > 0 {
            let testText = truncatedText + "..."
            let testAttributedText = NSMutableAttributedString(
                string: testText,
                attributes: [
                    .font: font,
                    .paragraphStyle: paragraphStyle
                ]
            )

            let testBoundingRect = testAttributedText.boundingRect(
                with: CGSize(width: labelWidth, height: maxHeight),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )

            if testBoundingRect.height <= maxHeight {
                return testAttributedText
            }
            truncatedText.removeLast()
        }

        return NSAttributedString(
            string: "...",
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]
        )
    }
    
    private func truncateText(content: String, font: UIFont, maxSize: CGSize) -> NSAttributedString {
        let ellipsis = "..."
        var truncatedContent = content
        
        while truncatedContent.count > 0 {
            let testContent = truncatedContent + ellipsis
            let testAttributedText = NSAttributedString(
                string: testContent,
                attributes: [
                    .font: font
                ]
            )
            let boundingRect = testAttributedText.boundingRect(
                with: maxSize,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )

            if boundingRect.height <= font.lineHeight * 3 {
                return NSMutableAttributedString(
                    string: testContent,
                    attributes: [
                        .font: font,
                        .paragraphStyle: NSMutableParagraphStyle(),
                        .foregroundColor: UIColor.black
                    ]
                )
            }

            truncatedContent = String(truncatedContent.dropLast())
        }

        return NSAttributedString(string: ellipsis)
    }
}
