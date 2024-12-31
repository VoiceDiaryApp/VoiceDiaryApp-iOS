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
    private var recordingEmotion: Emotion = .angry
    private var recordingTitle: String = ""
    private var recordingSummary: String = ""
    private let model = GenerativeModel(name: "gemini-1.5-flash-latest",
                                        apiKey: Config.apiKey)
    private let realmManager = RealmDiaryManager()
    private var geminiLetterContent: String = "" {
        didSet {
            geminiLetterSubject.send(geminiLetterContent)
        }
    }
    private let geminiLetterSubject = PassthroughSubject<String, Never>()
    
    struct Input {
        let onRecording: PassthroughSubject<String, Never>
        let tapRecordEnd: PassthroughSubject<Void, Never>
        let tapDrawEnd: PassthroughSubject<Emotion, Never>
        let viewWillAppear: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        var recordContent = CurrentValueSubject<String, Never>("")
        var geminiLetter = CurrentValueSubject<String, Never>("")
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.onRecording
            .sink { value in
                if value != "" {
                    self.recordingContent = value
                }
            }
            .store(in: &cancellables)
        
        input.tapRecordEnd
            .sink { _ in
                output.recordContent.send(self.recordingContent)
            }
            .store(in: &cancellables)
        
        input.tapDrawEnd
            .sink { value in
                self.generatePrompt(content: self.recordingContent,
                                    emotion: value,
                                    output: output)
            }
            .store(in: &cancellables)
        
        input.viewWillAppear
            .sink {
                output.geminiLetter.send(self.geminiLetterContent)
            }
            .store(in: &cancellables)
        
        geminiLetterSubject
            .receive(on: RunLoop.main)
            .sink { content in
                output.geminiLetter.send(content)
                self.saveDiaryToRealm()
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
            let letterContent = response.candidates.first?.content.parts.first?.text ?? "깨비가 답장을 쓰지 못했어요. \n다시 시도해주세요!"
            self.geminiLetterContent = letterContent
        } catch {
            print("Error: \(error)")
        }
    }
    
    func generatePrompt(content: String,
                        emotion: Emotion,
                        output: Output) {
        let generatedPrompt = "\"" + content + ". " + emotion.emotionToPrompt + "\"에 대한 답장을 써줘. 나는 일기를 쓰는 아이고 우리는 친구이지만 호칭은 너라고 해줘. 내가 쓴 일기를 너한테 보내면, 도깨비가 귀여운 말투로 나에게 답장을 써줘. 답장은 이모티콘 없이 편안하고 친근한 말투로, 내용은 조금 길고 따뜻한 감정이 담겨 있으면 좋겠어. 그리고 생략된 말이나 괄호는 없었으면 좋겠고 1문단으로 작성해줘."
        print("💭💭generatedPrompt💭💭")
        print(generatedPrompt)
        recordingEmotion = emotion
        Task {
            await generateGeminiLetter(prompt: generatedPrompt,
                                       output: output)
        }
        generateTitlePrompt(content: content,
                            emotion: emotion)
        generateSummaryPrompt(content: content,
                              emotion: emotion)
    }
    
    func generateTitlePrompt(content: String,
                             emotion: Emotion) {
        let generatedTitlePrompt = "\"" + content + ". " + emotion.emotionToPrompt + "\"의 일기를 썼어. 이 일기의 제목을 한줄로 만들어줘."
        print("💭💭generatedTitlePrompt💭💭")
        print(generatedTitlePrompt)
        Task {
            do {
                let response = try await model.generateContent(generatedTitlePrompt)
                let titleContent = response.candidates.first?.content.parts.first?.text ?? "오늘의 하루!"
                self.recordingTitle = titleContent
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func generateSummaryPrompt(content: String,
                               emotion: Emotion) {
        let generatedSummaryPrompt = "\"" + content + ". " + emotion.emotionToPrompt + "\"의 일기 내용을 간단하게 요약해줘."
        print("💭💭generatedSummaryPrompt💭💭")
        print(generatedSummaryPrompt)
        Task {
            do {
                let response = try await model.generateContent(generatedSummaryPrompt)
                let summaryContent = response.candidates.first?.content.parts.first?.text ?? "오늘의 하루는 어땠냐면.."
                self.recordingSummary = summaryContent
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func saveDiaryToRealm() {
        self.realmManager.saveDiaryEntry(WriteDiaryEntry(
            date: Date().dateToString(),
            emotion: self.recordingEmotion,
            content: self.recordingContent,
            shortContent: self.recordingSummary,
            title: self.recordingTitle,
            answer: self.geminiLetterContent,
            drawImage: ""))
    }
}
