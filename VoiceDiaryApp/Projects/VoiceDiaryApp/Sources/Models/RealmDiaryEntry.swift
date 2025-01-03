//
//  RealmDiaryEntry.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import Foundation
import RealmSwift

final class RealmDiaryEntry: Object {
    @Persisted(primaryKey: true) var createDate: String
//    @Persisted var date: Date
    @Persisted var emotion: String
    @Persisted var content: String
    @Persisted var shortContent: String
    @Persisted var title: String
    @Persisted var answer: String
    @Persisted var drawImage: String
    
    // WriteDiaryEntry로 변환
    func toWriteDiaryEntry() -> WriteDiaryEntry {
        return WriteDiaryEntry(
            date: self.createDate,
            emotion: Emotion(rawValue: self.emotion) ?? .neutral,
            content: self.content,
            shortContent: self.shortContent,
            title: self.title,
            answer: self.answer,
            drawImage: self.drawImage
        )
    }
}
