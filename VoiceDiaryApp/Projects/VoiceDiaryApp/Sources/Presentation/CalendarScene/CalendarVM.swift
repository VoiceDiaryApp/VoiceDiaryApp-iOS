//
//  CalendarVM.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import Foundation
import Combine
import RealmSwift

protocol CalendarVMProtocol {
    var diaryEntries: [WriteDiaryEntry] { get }
    var diaryEntriesPublisher: Published<[WriteDiaryEntry]>.Publisher { get }
    func fetchDiary(for date: Date)
    func addDiaryEntry(for date: Date, emotion: Emotion, content: String)
}

final class CalendarVM: CalendarVMProtocol {
    @Published private(set) var diaryEntries: [WriteDiaryEntry] = []
    
    var diaryEntriesPublisher: Published<[WriteDiaryEntry]>.Publisher { $diaryEntries }
    private let diaryManager = RealmDiaryManager()
    
    func fetchDiary(for date: Date) {
        print("Fetching diary for date: \(date)")
        if let diaryEntry = diaryManager.fetchDiaryEntry(for: date) {
            print("Found diary entry: \(diaryEntry)")
            diaryEntries = [diaryEntry.toWriteDiaryEntry()]
        } else {
            print("No diary entry found for date: \(date)")
            diaryEntries = []
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .diaryUpdated, object: nil)
        }
    }
    
    func addDiaryEntry(for date: Date, emotion: Emotion, content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        var existingEntry = diaryManager.fetchDiaryEntry(for: date)
        
        let diaryEntry = WriteDiaryEntry(
            date: dateString,
            emotion: emotion,
            content: content,
            shortContent: existingEntry?.shortContent.replacingOccurrences(of: "\n", with: "") ?? "",
            title: existingEntry?.title.replacingOccurrences(of: "\n", with: "") ?? "",
            answer: existingEntry?.answer.replacingOccurrences(of: "\n", with: "") ?? "",
            drawImage: existingEntry?.drawImage ?? ""
        )
        
        diaryManager.saveDiaryEntry(diaryEntry)
        fetchDiary(for: date)
    }
}

extension Notification.Name {
    static let diaryUpdated = Notification.Name("diaryUpdated")
}
