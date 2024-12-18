//
//  Diary2View.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit
import PencilKit

protocol Diary2ViewDelegate: AnyObject {
    func saveButtonTapped()
}

final class Diary2View: UIView {
    
    weak var delegate: Diary2ViewDelegate?
    
    // MARK: - Properties
    private var selectedEmotion: Emotion?
    private let emotions: [Emotion] = [.happy, .smiling, .neutral, .angry, .sad, .tired]
    private var emotionButtons: [UIButton] = []
    private let canvasView = PKCanvasView()
    
    private var currentColor: UIColor = .black
    private let colorPickerVC = UIColorPickerViewController()
    
    // Tool Buttons
    private let toolEraser = UIButton()
    private let toolPencil = UIButton()
    private let toolFinePen = UIButton()
    private let toolBoldPen = UIButton()
    private let toolCalligraphyPen = UIButton()
    private let toolColorPicker = UIButton()
    
    // MARK: - UI Components
    
    private let navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.setTitleLabel = "일기 쓰기"
        return navigationBar
    }()
    
    private let moodEmojiView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let toolView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        stackView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        stackView.layer.shadowOpacity = 1
        stackView.layer.shadowOffset = CGSize(width: 0, height: -3)
        stackView.layer.shadowRadius = 4
        stackView.layer.masksToBounds = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 26)
        
        return stackView
    }()
    
    private let linkedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("기록하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(resource: .mainYellow)
        button.titleLabel?.font = UIFont.fontGuide(type: .PretandardSemiBold, size: 17)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupHierarchy()
        setupLayout()
        setupEmotionButtons()
        setupPencilKit()
        setupToolButtons()
        setupColorPicker()
        setupSaveButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIColor(resource: .mainBeige)
    }
    
    private func setupHierarchy() {
        addSubviews(navigationBar, moodEmojiView, canvasView, linkedView, toolView, saveButton)
    }
    
    private func setupLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        moodEmojiView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(46)
        }
        
        canvasView.snp.makeConstraints { make in
            make.top.equalTo(moodEmojiView.snp.bottom).offset(57)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(306)
        }
        
        linkedView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(canvasView)
            make.top.equalTo(canvasView.snp.bottom).offset(-8)
            make.bottom.equalTo(toolView.snp.top).offset(8)
        }
        
        toolView.snp.makeConstraints { make in
            make.top.equalTo(canvasView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(72)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(44)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.height.equalTo(57)
        }
    }
    
    // MARK: - PencilKit Setup
    
    private func setupPencilKit() {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .white
        canvasView.layer.cornerRadius = 8
        canvasView.tool = PKInkingTool(.pencil, color: currentColor, width: 5)
    }
    // MARK: - Emotion Buttons Setup
    
    private func setupEmotionButtons() {
        emotions.forEach { emotion in
            let button = UIButton()
            button.setImage(UIImage(named: emotion.rawValue), for: .normal)
            button.contentMode = .scaleAspectFit
            button.tag = emotions.firstIndex(of: emotion) ?? 0
            button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
            moodEmojiView.addArrangedSubview(button)
            emotionButtons.append(button)
        }
    }
    
    // MARK: - Tool Buttons Setup
    
    private func setupToolButtons() {
        let tools = [(toolEraser, "tool_Eraser"),
                     (toolPencil, "tool_Pencil"),
                     (toolFinePen, "tool_FinePen"),
                     (toolBoldPen, "tool_BoldPen"),
                     (toolCalligraphyPen, "tool_CalligraphyPen")]
        
        let toolContainer = UIStackView()
        toolContainer.axis = .horizontal
        toolContainer.distribution = .equalSpacing
        toolContainer.alignment = .center
        toolView.addSubview(toolContainer)
        toolView.addSubview(toolColorPicker)
        
        tools.forEach { (button, imageName) in
            let image = UIImage(named: imageName)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(toolButtonTapped(_:)), for: .touchUpInside)
            toolContainer.addArrangedSubview(button)
        }
        
        toolContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(toolColorPicker.snp.leading).offset(-43)
            make.top.bottom.equalToSuperview()
        }
        
        toolColorPicker.layer.cornerRadius = 22
        toolColorPicker.layer.borderWidth = 8.5
        toolColorPicker.layer.borderColor = currentColor.cgColor
        toolColorPicker.layer.masksToBounds = true
        toolColorPicker.isUserInteractionEnabled = true
        
        let innerCircle = UIView()
        innerCircle.backgroundColor = .white
        innerCircle.layer.cornerRadius = 13.5
        innerCircle.layer.masksToBounds = true
        innerCircle.isUserInteractionEnabled = false
        toolColorPicker.addSubview(innerCircle)
        
        innerCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(27)
        }
        
        toolColorPicker.addTarget(self, action: #selector(colorPickerTapped), for: .touchUpInside)
        
        toolColorPicker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-26)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    @objc private func colorPickerTapped() {
        presentColorPicker()
    }
    
    private func presentColorPicker() {
        guard let topController = findTopViewController() else { return }
        topController.present(colorPickerVC, animated: true, completion: nil)
    }
    
    private func findTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return nil }
        
        var topController = keyWindow.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    // MARK: - Color Picker Setup
    
    private func setupColorPicker() {
        colorPickerVC.delegate = self
    }
    
    // MARK: - Actions
    @objc private func emotionButtonTapped(_ sender: UIButton) {
        let tappedEmotion = emotions[sender.tag]
        updateSelectedEmotion(to: tappedEmotion)
        self.makeVibrate(degree: .medium)
    }
    
    private func updateSelectedEmotion(to newEmotion: Emotion) {
        selectedEmotion = newEmotion
        for (index, button) in emotionButtons.enumerated() {
            let emotion = emotions[index]
            let imageName = (emotion == newEmotion) ? "\(emotion.rawValue)_stroke" : emotion.rawValue
            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    @objc private func toolButtonTapped(_ sender: UIButton) {
        if sender == toolEraser {
            canvasView.tool = PKEraserTool(.vector)
        } else if sender == toolPencil {
            canvasView.tool = PKInkingTool(.pencil, color: currentColor, width: 5)
        } else if sender == toolFinePen {
            canvasView.tool = PKInkingTool(.pen, color: currentColor, width: 2)
        } else if sender == toolBoldPen {
            canvasView.tool = PKInkingTool(.pen, color: currentColor, width: 8)
        } else if sender == toolCalligraphyPen {
            canvasView.tool = PKInkingTool(.marker, color: currentColor, width: 5)
        } else if sender == toolColorPicker {
            presentColorPicker()
        }
    }
    
    private func setupSaveButtonAction() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        delegate?.saveButtonTapped()
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension Diary2View: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateColorPickerButtonColor(to: viewController.selectedColor)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateColorPickerButtonColor(to: viewController.selectedColor)
    }
    
    private func updateColorPickerButtonColor(to color: UIColor) {
        currentColor = color
        toolColorPicker.tintColor = color
        toolColorPicker.layer.borderColor = color.cgColor
        canvasView.tool = PKInkingTool(.pencil, color: currentColor, width: 5)
    }
}
