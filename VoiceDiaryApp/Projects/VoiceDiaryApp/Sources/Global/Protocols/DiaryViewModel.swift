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

final class DiaryViewModel: DiaryViewModelProtocol {
    @Published private(set) var diaryEntries: [DiaryEntry] = []

    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { $diaryEntries }

    init() {
        diaryEntries = []
        loadInitialDiaryData()
    }

    private func loadInitialDiaryData() {
        fetchDiary(for: Date())
    }

    func fetchDiary(for date: Date) {
        let key = dateKey(for: date)
        if let savedData = UserDefaults.standard.data(forKey: key),
           let diaryEntry = try? JSONDecoder().decode(DiaryEntry.self, from: savedData) {
            diaryEntries = [diaryEntry]
        } else {
            diaryEntries = []
        }
    }

    func addDiaryEntry(for date: Date, emotion: Emotion, content: String) {
        let key = dateKey(for: date)
        let diaryEntry = DiaryEntry(date: date, emotion: emotion, content: content)

        if let encodedData = try? JSONEncoder().encode(diaryEntry) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }

        if let index = diaryEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            diaryEntries[index] = diaryEntry
        } else {
            diaryEntries.append(diaryEntry)
        }
    }

    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
