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
    var selectedEntry: DiaryEntry? { get }
    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { get }
    var selectedEntryPublisher: Published<DiaryEntry?>.Publisher { get }
    func fetchDiary(for date: Date)
    func addDiaryEntry(for date: Date, emotion: Emotion, content: String)
}

class DiaryViewModel: DiaryViewModelProtocol {
    @Published private(set) var diaryEntries: [DiaryEntry] = []
    @Published private(set) var selectedEntry: DiaryEntry?

    var diaryEntriesPublisher: Published<[DiaryEntry]>.Publisher { $diaryEntries }
    var selectedEntryPublisher: Published<DiaryEntry?>.Publisher { $selectedEntry }

    func fetchDiary(for date: Date) {
        if let entry = diaryEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            selectedEntry = entry
        } else {
            selectedEntry = nil
        }
    }

    func addDiaryEntry(for date: Date, emotion: Emotion, content: String) {
        let newEntry = DiaryEntry(date: date, emotion: emotion, content: content)
        diaryEntries.append(newEntry)
    }
}
