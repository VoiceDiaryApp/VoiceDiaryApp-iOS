//
//  RealmDiaryEntry+Conversion.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import Foundation

extension RealmDiaryEntry {
    // RealmDiaryEntry -> DiaryEntry 객체 변환
    func toDiaryEntry() -> DiaryEntry {
        return DiaryEntry(
            date: self.date.toLocalTime(),
            emotion: Emotion(rawValue: self.emotion) ?? .neutral,
            content: self.content
        )
    }
}
