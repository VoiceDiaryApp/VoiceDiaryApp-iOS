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
        diaryEntries = generateMockDiaryEntries()
    }

    private func generateMockDiaryEntries() -> [DiaryEntry] {
        let calendar = Calendar.current
        let now = Date()

        guard let currentMonthRange = calendar.range(of: .day, in: .month, for: now),
              let firstDayOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let previousMonth = calendar.date(byAdding: .month, value: -1, to: now),
              let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth),
              let firstDayOfPreviousMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: previousMonth)),
              let nextMonth = calendar.date(byAdding: .month, value: 1, to: now),
              let nextMonthRange = calendar.range(of: .day, in: .month, for: nextMonth),
              let firstDayOfNextMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth)) else {
            return []
        }

        var entries: [DiaryEntry] = []

        // 이번 달 목데이터
        for day in currentMonthRange where day % 3 == 0 { // 3일 간격으로 데이터 추가
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfCurrentMonth)!
            let emotion: Emotion = day % 2 == 0 ? .happy : .neutral
            let content = "오늘의 일기 \(day)일 내용"
            entries.append(DiaryEntry(date: date, emotion: emotion, content: content))
        }

        // 이전 달 목데이터
        for day in previousMonthRange where day % 4 == 0 {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfPreviousMonth)!
            let emotion: Emotion = day % 2 == 0 ? .angry : .sad
            let content = "지난 달 \(day)일 일기"
            entries.append(DiaryEntry(date: date, emotion: emotion, content: content))
        }

        // 다음 달 목데이터
        for day in nextMonthRange where day % 5 == 0 {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfNextMonth)!
            let emotion: Emotion = day % 2 == 0 ? .smiling : .tired
            let content = "다음 달 \(day)일에 쓴 일기"
            entries.append(DiaryEntry(date: date, emotion: emotion, content: content))
        }

        return entries
    }

    func fetchDiary(for date: Date) {
        // 특정 날짜의 일기 가져오기
    }

    func addDiaryEntry(for date: Date, emotion: Emotion, content: String) {
        if let index = diaryEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            diaryEntries[index] = DiaryEntry(date: date, emotion: emotion, content: content)
        } else {
            diaryEntries.append(DiaryEntry(date: date, emotion: emotion, content: content))
        }
    }
}
