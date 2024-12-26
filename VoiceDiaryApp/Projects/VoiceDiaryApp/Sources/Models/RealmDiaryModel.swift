//
//  RealmDiaryModel.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/4/24.
//

import Foundation
import RealmSwift

final class RealmDiaryEntry: Object {
    @Persisted(primaryKey: true) var id: ObjectId   // 기본 키
    @Persisted var hasDiary: Bool = false           // 오늘 일기 여부
    @Persisted var date: Date                       // 일기 날짜
    @Persisted var emotion: String                  // 감정 (Emotion Enum의 rawValue 저장)
    @Persisted var content: String                  // 일기 내용
    @Persisted var shortContent: String             // 일기 요약
    @Persisted var title: String                    // 일기 제목
    @Persisted var emoticons: String                // 이모지
    @Persisted var hasImage: Bool = false           // 이미지 여부
    @Persisted var answer: String                   // 답장
}

extension RealmDiaryEntry {
    func toDiaryEntry() -> DiaryEntry {
        return DiaryEntry(
            date: self.date,
            emotion: Emotion(rawValue: self.emotion) ?? .neutral,
            content: self.content
        )
    }
}

extension DiaryEntry {
    func toRealmDiaryEntry() -> RealmDiaryEntry {
        let realmEntry = RealmDiaryEntry()
        realmEntry.date = self.date
        realmEntry.emotion = self.emotion.rawValue
        realmEntry.content = self.content
        return realmEntry
    }
}

final class RealmDiaryManager {
    private let realm: Realm

    init() {
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: RealmDiaryEntry.className()) { _, newObject in
                        newObject?["hasDiary"] = false
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
    }

    func saveDiaryEntry(_ diaryEntry: DiaryEntry) {
        let realmEntry = diaryEntry.toRealmDiaryEntry()
        try! realm.write {
            realm.add(realmEntry, update: .all)
        }
    }

    func fetchDiaryEntry(for date: Date) -> DiaryEntry? {
        let results = realm.objects(RealmDiaryEntry.self).filter("date == %@", date)
        return results.first?.toDiaryEntry()
    }

    func fetchAllDiaryEntries() -> [DiaryEntry] {
        return realm.objects(RealmDiaryEntry.self).map { $0.toDiaryEntry() }
    }
}
