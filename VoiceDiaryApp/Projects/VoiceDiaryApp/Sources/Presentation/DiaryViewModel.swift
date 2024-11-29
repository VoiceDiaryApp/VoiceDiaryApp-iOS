//
//  DiaryViewModel.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import UIKit
import Combine

class DiaryViewModel {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var diaryEntries: [DiaryEntry] = []
    @Published var selectedEntry: DiaryEntry?
    
    init() {
        
    }
    
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
