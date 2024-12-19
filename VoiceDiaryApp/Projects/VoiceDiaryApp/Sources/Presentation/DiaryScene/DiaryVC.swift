//
//  DiaryVC.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/3/24.
//

import UIKit

import SnapKit
import Combine
import Speech
import Accelerate

final class DiaryVC: UIViewController {
    
    // MARK: - Properties
    
    enum SpeechRecognitionOutput {
        case success(String) // 인식 성공
        case error(Error) // 인식 실패
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private var isTranscribing: Bool = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let diaryVM = DiaryVM()
    private let onRecording = PassthroughSubject<String, Never>()
    private let tapRecordEnd = PassthroughSubject<Void, Never>()
    private var recordedContent: String = ""
    
    // MARK: - UI Components
    
    private let navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.setTitleLabel = "일기 쓰기"
        return navigationBar
    }()
    
    private let microphoneStartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnMicrophoneStart), for: .normal)
        button.setImage(UIImage(resource: .btnMicrophoneStartDisabled), for: .disabled)
        return button
    }()
    
    private let microphoneEndButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnMicrophoneEnd), for: .normal)
        button.setImage(UIImage(resource: .btnMicrophoneEndDisabled), for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private let goToDrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("그림 그리러 가기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(resource: .calendarTextBlack), for: .disabled)
        button.setBackgroundColor(UIColor(resource: .mainYellow), for: .normal)
        button.setBackgroundColor(UIColor(resource: .mainYellow).withAlphaComponent(0.5),
                                  for: .disabled)
        button.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    private let microphoneStartLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 시작"
        label.textColor = UIColor(resource: .calendarSelected)
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private let microphoneEndLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 중지"
        label.textColor = UIColor(resource: .btnUnselected)
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private var microphoneLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .fontGuide(type: .PretandardMedium, size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        bindViewModel()
    }
}

private extension DiaryVC {
    
    func setUI() {
        view.backgroundColor = UIColor(resource: .mainBeige)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        navigationBar.backButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        microphoneStartButton.tapPublisher
            .sink(receiveValue: {
                self.goToDrawButton.isEnabled = false
                self.startTranscribing()
            })
            .store(in: &cancellables)
        
        microphoneEndButton.tapPublisher
            .sink(receiveValue: {
                self.tapRecordEnd.send()
                self.stopTranscribing()
            })
            .store(in: &cancellables)
        
        goToDrawButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                let diary2VC = Diary2VC(viewModel: self.diaryVM)
                self.navigationController?.pushViewController(diary2VC, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    func bindViewModel() {
        let input = DiaryVM.Input(
            onRecording: self.onRecording,
            tapRecordEnd: self.tapRecordEnd,
            tapDrawEnd: PassthroughSubject()
        )
        
        let output = diaryVM.transform(input: input)
        output.recordContent.sink(receiveValue: { value in
            self.goToDrawButton.isEnabled = (value != "")
            self.microphoneLabel.text = value
            self.recordedContent = value
        })
        .store(in: &cancellables)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         microphoneLabel,
                         microphoneStartButton,
                         microphoneEndButton,
                         goToDrawButton,
                         microphoneStartLabel,
                         microphoneEndLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.calSupporHeight(height: 55))
            
        }
        
        microphoneLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            $0.leading.trailing.equalToSuperview().inset(75)
            $0.centerX.equalToSuperview()
        }
        
        goToDrawButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 87)
            $0.height.equalTo(57)
        }
        
        microphoneStartLabel.snp.makeConstraints {
            $0.bottom.equalTo(goToDrawButton.snp.top).offset(-50)
            $0.centerX.equalTo(microphoneStartButton)
        }
        
        microphoneStartButton.snp.makeConstraints {
            $0.bottom.equalTo(microphoneStartLabel.snp.top).offset(-10)
            $0.leading.equalToSuperview().inset((SizeLiterals.Screen.screenWidth - SizeLiterals.calSupporWidth(width: 75) * 2 - 60) / 2)
            $0.size.equalTo(SizeLiterals.calSupporWidth(width: 75))
        }
        
        microphoneEndLabel.snp.makeConstraints {
            $0.bottom.equalTo(goToDrawButton.snp.top).offset(-50)
            $0.centerX.equalTo(microphoneEndButton)
        }
        
        microphoneEndButton.snp.makeConstraints {
            $0.bottom.equalTo(microphoneEndLabel.snp.top).offset(-10)
            $0.trailing.equalToSuperview().inset((SizeLiterals.Screen.screenWidth - SizeLiterals.calSupporWidth(width: 75) * 2 - 60) / 2)
            $0.size.equalTo(SizeLiterals.calSupporWidth(width: 75))
        }
    }
    
    func startTranscribing() {
        guard !isTranscribing else { return }
        isTranscribing = true
        microphoneStartButton.isEnabled = !isTranscribing
        microphoneEndButton.isEnabled = isTranscribing
        microphoneStartLabel.textColor = UIColor(resource: .btnUnselected)
        microphoneEndLabel.textColor = UIColor(resource: .calendarSelected)
        
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
            isTranscribing = false
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            isTranscribing = false
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                DispatchQueue.main.async {
                    self.microphoneLabel.text = result.bestTranscription.formattedString
                    self.onRecording.send(result.bestTranscription.formattedString)
                }
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                self.stopTranscribing()
            }
        }
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("오디오 엔진 시작 실패: \(error)")
            stopTranscribing()
        }
    }
    
    func stopTranscribing() {
        microphoneLabel.text = recordedContent
        recognitionTask?.cancel()
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        isTranscribing = false
        microphoneStartButton.isEnabled = !isTranscribing
        microphoneEndButton.isEnabled = isTranscribing
        microphoneStartLabel.textColor = UIColor(resource: .calendarSelected)
        microphoneEndLabel.textColor = UIColor(resource: .btnUnselected)
    }
}
