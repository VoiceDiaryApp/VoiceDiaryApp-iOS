//
//  CalendarVM.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import Foundation
import Combine

protocol CalendarVMProtocol {
    var diaryEntries: [DiaryEntry] { get }
    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { get }
    func fetchDiary(for date: Date)
    func addDiaryEntry(for date: Date, emotion: Emotion, content: String)
}

final class CalendarVM: CalendarVMProtocol {
    @Published private(set) var diaryEntries: [DiaryEntry] = []

    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { $diaryEntries }
    private let diaryManager = RealmDiaryManager()

    func fetchDiary(for date: Date) {
        if let diaryEntry = diaryManager.fetchDiaryEntry(for: date) {
            diaryEntries = [diaryEntry]
        } else {
            diaryEntries = []
        }
    }

    func addDiaryEntry(for date: Date, emotion: Emotion, content: String) {
        let diaryEntry = DiaryEntry(date: date, emotion: emotion, content: content)
        diaryManager.saveDiaryEntry(diaryEntry)
        fetchDiary(for: date)
    }
}
