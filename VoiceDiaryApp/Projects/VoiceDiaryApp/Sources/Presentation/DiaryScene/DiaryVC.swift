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
    private let tapRecordEnd = PassthroughSubject<String, Never>()
    
    // MARK: - UI Components
    
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
        button.backgroundColor = .green
        button.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let microphoneStartLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 시작"
        label.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        return label
    }()
    
    private let microphoneEndLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 중지"
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
        view.backgroundColor  = .white
        
        microphoneStartButton.tapPublisher
            .sink(receiveValue: {
                self.goToDrawButton.isHidden = true
                self.startTranscribing()
            })
            .store(in: &cancellables)
        
        microphoneEndButton.tapPublisher
            .sink(receiveValue: {
                self.tapRecordEnd.send(self.microphoneLabel.text ?? "")
                if self.microphoneLabel.text != "" {
                    self.goToDrawButton.isHidden = false
                }
                self.stopTranscribing()
            })
            .store(in: &cancellables)
        
        goToDrawButton.tapPublisher
            .sink(receiveValue: {
                print("goToDrawVC")
            })
            .store(in: &cancellables)
        
    }
    
    func bindViewModel() {
        let input = DiaryVM.Input(
            tapRecordEnd: self.tapRecordEnd
        )
        let output = diaryVM.transform(input: input)
    }
    
    func setHierarchy() {
        view.addSubviews(microphoneLabel,
                         microphoneStartButton,
                         microphoneEndButton,
                         goToDrawButton,
                         microphoneStartLabel,
                         microphoneEndLabel)
    }
    
    func setLayout() {
        microphoneLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        goToDrawButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-117)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 87)
            $0.height.equalTo(57)
        }
        
        microphoneStartLabel.snp.makeConstraints {
            $0.bottom.equalTo(goToDrawButton.snp.top).offset(-32)
            $0.centerX.equalTo(microphoneStartButton)
        }
        
        microphoneStartButton.snp.makeConstraints {
            $0.bottom.equalTo(microphoneStartLabel.snp.top)
            $0.leading.equalToSuperview().inset((SizeLiterals.Screen.screenWidth - SizeLiterals.calSupporWidth(width: 75) * 2 - 60) / 2)
            $0.size.equalTo(SizeLiterals.calSupporWidth(width: 75))
        }
        
        microphoneEndLabel.snp.makeConstraints {
            $0.bottom.equalTo(goToDrawButton.snp.top).offset(-32)
            $0.centerX.equalTo(microphoneEndButton)
        }
        
        microphoneEndButton.snp.makeConstraints {
            $0.bottom.equalTo(microphoneEndLabel.snp.top)
            $0.trailing.equalToSuperview().inset((SizeLiterals.Screen.screenWidth - SizeLiterals.calSupporWidth(width: 75) * 2 - 60) / 2)
            $0.size.equalTo(SizeLiterals.calSupporWidth(width: 75))
        }
    }
    
    func startTranscribing() {
        guard !isTranscribing else { return }
        isTranscribing = true
        microphoneStartButton.isEnabled = !isTranscribing
        microphoneEndButton.isEnabled = isTranscribing
        
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
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.cleanup()
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
            cleanup()
        }
    }
    
    func stopTranscribing() {
        recognitionTask?.cancel()
        cleanup()
    }
    
    func cleanup() {
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
    }
}
