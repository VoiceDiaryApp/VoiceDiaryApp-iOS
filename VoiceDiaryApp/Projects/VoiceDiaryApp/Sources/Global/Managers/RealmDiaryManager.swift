//
//  RealmDiaryManager.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import Foundation
import RealmSwift

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
        let utcDate = date.toUTC()
        let results = realm.objects(RealmDiaryEntry.self).filter("date == %@", utcDate)
        return results.first?.toDiaryEntry()
    }

    func fetchAllDiaryEntries() -> [DiaryEntry] {
        return realm.objects(RealmDiaryEntry.self).map { $0.toDiaryEntry() }
    }
}
