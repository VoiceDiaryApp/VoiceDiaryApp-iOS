//
//  DiaryVM.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/9/24.
//
import Foundation

import Combine
import GoogleGenerativeAI

final class DiaryVM: ViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var recordingContent: String = ""
    private let model = GenerativeModel(name: "gemini-1.5-flash-latest",
                                        apiKey: Config.apiKey)
    
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
        
        input.onRecording
            .sink { value in
                self.recordingContent = value
            }
            .store(in: &cancellables)
        
        input.tapRecordEnd
            .sink { _ in
                print("🥹🥹🥹🥹")
                print(self.recordingContent)
                output.recordContent.send(self.recordingContent)
            }
            .store(in: &cancellables)
        
        input.tapDrawEnd
            .sink { value in
                print("🥹🥹🥹🥹")
                print(self.recordingContent)
                print(output.recordContent.value)
                self.generatePrompt(content: output.recordContent.value,
                                    emotion: value,
                                    output: output)
            }
            .store(in: &cancellables)
        
        return output
    }
}

private extension DiaryVM {
    
    func generateGeminiLetter(prompt: String,
                              output: Output) async {
        let prompt = prompt
        do {
            let response = try await model.generateContent(prompt)
            let letterContent = response.candidates.first?.content.parts.first?.text ??  "깨비가 답장을 쓰지 못했어요. \n다시 시도해주세요!"
            print("🎃🎃outputcontent🎃🎃")
            print(letterContent)
            print("🎃🎃🎃🎃")
            output.geminiLetter.send(letterContent)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func generatePrompt(content: String,
                        emotion: Emotion,
                        output: Output) {
        let generatedPrompt = "\"" + content + emotion.emotionToPrompt + "\"에 대한 답장을 써줘. 나는 일기를 쓰는 아이고 우리는 친구야. 내가 쓴 일기를 너한테 보내면, 도깨비가 귀여운 말투로 나에게 답장을 써줘. 답장은 이모티콘 없이 편안하고 친근한 말투로, 내용은 조금 길고 따뜻한 감정이 담겨 있으면 좋겠어."
        print("💭💭generatedPrompt💭💭")
        print(generatedPrompt)
        Task {
            await generateGeminiLetter(prompt: generatedPrompt,
                                       output: output)
        }
    }
}
