//
//  DiaryVM.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/9/24.
//

import Combine

final class DiaryVM: ViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var recordingContent: String = ""
    
    struct Input {
        let onRecording: PassthroughSubject<String, Never>
        let tapRecordEnd: PassthroughSubject<Void, Never>
        let tapDrawEnd: PassthroughSubject<Emotion, Never>
    }
    
    struct Output {
        var recordContent = CurrentValueSubject<String, Never>("")
        var geminiLetter = CurrentValueSubject<String, Never>("")
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        self.bindOutput(output: output)
        
        input.onRecording
            .sink { value in
                self.recordingContent = value
            }
            .store(in: &cancellables)
        
        input.tapRecordEnd
            .sink { _ in
                print("✅✅recordingcontent✅✅")
                print(self.recordingContent)
                output.recordContent.send(self.recordingContent)
            }
            .store(in: &cancellables)
        
        input.tapDrawEnd
            .sink { value in
                print("✅✅selectemotion✅✅")
                print(value)
            }
            .store(in: &cancellables)
        
        return output
    }
    
    private func bindOutput(output: Output) {
        
    }
}
