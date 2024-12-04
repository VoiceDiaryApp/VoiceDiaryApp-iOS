//
//  DiaryViewModel.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import Foundation
import Combine

protocol DiaryViewModelProtocol {
    var diaryEntries: [DiaryEntry] { get }
    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { get }
    func fetchDiary(for date: Date)
    func addDiaryEntry(for date: Date, emotion: Emotion, content: String)
}

class DiaryViewModel: DiaryViewModelProtocol {
    @Published private(set) var diaryEntries: [DiaryEntry] = []

    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { $diaryEntries }

    init() {
        diaryEntries = generateDiaryEntriesForCurrentMonth()
    }

    private func generateDiaryEntriesForCurrentMonth() -> [DiaryEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        guard let range = calendar.range(of: .day, in: .month, for: now),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }
        
        return range.compactMap { day -> DiaryEntry in
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            return DiaryEntry(date: date, emotion: .neutral, content: "")
        }
    }

    func fetchDiary(for date: Date) {
        // 특정 날짜에 대한 다이어리 항목 가져오기 로직
    }

    func addDiaryEntry(for date: Date, emotion: Emotion, content: String) {
        if let index = diaryEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            diaryEntries[index] = DiaryEntry(date: date, emotion: emotion, content: content)
        }
    }
}
