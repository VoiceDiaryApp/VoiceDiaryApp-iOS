//
//  WriteDiaryEntry.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/27/24.
//


struct WriteDiaryEntry: Codable {
    let date: String
    let emotion: Emotion
    let content: String
    let shortContent: String
    let title: String
    let answer: String
    let drawImage: String
    
    // RealmDiaryEntry로 변환
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
