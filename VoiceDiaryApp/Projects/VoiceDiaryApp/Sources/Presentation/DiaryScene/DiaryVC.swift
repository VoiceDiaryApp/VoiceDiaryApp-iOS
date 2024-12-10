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
    
    // MARK: - UI Components
    
    private let microphoneStartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnMicrophoneStart), for: .normal)
        return button
    }()
    
    private let microphoneEndButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnMicrophoneEnd), for: .normal)
        return button
    }()
    
    private let goToDrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("그림 그리러 가기", for: .normal)
        button.titleLabel?.font = .fontGuide(type: .PretandardSemiBold, size: 17)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = "버튼을 누르고 말해보세요!"
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
    }
}

private extension DiaryVC {
    
    func setUI() {
        view.backgroundColor  = .white
        
        microphoneStartButton.tapPublisher
            .sink(receiveValue: {
                self.startTranscribing()
            })
            .store(in: &cancellables)
        
        microphoneEndButton.tapPublisher
            .sink(receiveValue: {
                self.stopTranscribing()
            })
            .store(in: &cancellables)
        
    }
    
    func setHierarchy() {
        view.addSubviews(microphoneLabel,
                         microphoneStartButton,
                         microphoneEndButton,
                         goToDrawButton,
                         explainLabel)
    }
    
    func setLayout() {
        microphoneLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        explainLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-117)
            $0.centerX.equalToSuperview()
        }
        
        microphoneStartButton.snp.makeConstraints {
            $0.bottom.equalTo(explainLabel.snp.top)
            $0.leading.equalToSuperview().inset(100)
            $0.size.equalTo(104)
        }
        
        microphoneEndButton.snp.makeConstraints {
            $0.bottom.equalTo(explainLabel.snp.top)
            $0.leading.equalTo(microphoneStartButton.snp.trailing).offset(20)
            $0.size.equalTo(104)
        }
    }
    
    func startTranscribing() {
        guard !isTranscribing else { return }
        isTranscribing = true
        
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
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        isTranscribing = false
    }
}
