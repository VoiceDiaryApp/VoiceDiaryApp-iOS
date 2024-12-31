//
//  WriteDiary+Conversion.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/27/24.
//

extension WriteDiaryEntry {
    // WriteDiaryEntry -> RealmDiaryEntry
    func toRealmDiaryEntry() -> RealmDiaryEntry {
        let realmEntry = RealmDiaryEntry()
        realmEntry.createDate = self.date
        realmEntry.emotion = self.emotion.rawValue
        realmEntry.content = self.content
        realmEntry.shortContent = self.shortContent
        realmEntry.title = self.title
        realmEntry.answer = self.answer
        realmEntry.drawImage = self.drawImage
        return realmEntry
    }
}

