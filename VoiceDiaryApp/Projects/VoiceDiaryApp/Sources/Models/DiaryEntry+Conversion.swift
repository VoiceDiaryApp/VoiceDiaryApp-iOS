//
//  DiaryEntry+Conversion.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import Foundation

extension DiaryEntry {
    // DiaryEntry -> RealmDiaryEntry
    func toRealmDiaryEntry() -> RealmDiaryEntry {
        let realmEntry = RealmDiaryEntry()
        realmEntry.date = self.date.toUTC()
        realmEntry.emotion = self.emotion.rawValue
        realmEntry.content = self.content
        return realmEntry
    }
}
