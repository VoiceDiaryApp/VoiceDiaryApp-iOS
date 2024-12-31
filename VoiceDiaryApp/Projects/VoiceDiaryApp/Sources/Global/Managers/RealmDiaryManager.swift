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
    private let dateFormatter: DateFormatter

    init() {
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    migration.enumerateObjects(ofType: RealmDiaryEntry.className()) { oldObject, newObject in
                        newObject?["drawImage"] = ""
                        if let oldDate = oldObject?["date"] as? Date {
                            newObject?["createDate"] = oldDate.dateToString() + UUID().uuidString
                        }
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            print("❌ Realm 초기화 실패: \(error.localizedDescription)")
            fatalError("Realm 초기화 실패")
        }

        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func saveDiaryEntry(_ diaryEntry: WriteDiaryEntry) {
        print("⭐️⭐️saveDiaryEntry⭐️⭐️")
        print(diaryEntry)
        let realmEntry = diaryEntry.toRealmDiaryEntry()
        try! realm.write {
            realm.add(realmEntry, update: .all)
        }
    }
    
    func delAllEntry() {
        do {
            let realm = try Realm()
            try realm.write {
                let allDiaryEntries = realm.objects(RealmDiaryEntry.self)
                realm.delete(allDiaryEntries)
            }
            print("모든 데이터가 성공적으로 삭제되었습니다.")
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
    
    
    func hasTodayDiary() -> Bool {
        let todayString = dateFormatter.string(from: Date())
        return realm.objects(RealmDiaryEntry.self).filter("createDate == %@", todayString).first != nil
    }
    
    func fetchDiaryEntry(for date: Date) -> RealmDiaryEntry? {
        let targetDateString = dateFormatter.string(from: date)
        return realm.objects(RealmDiaryEntry.self).filter("createDate == %@", targetDateString).first
    }

    func fetchDiaryEntries(for date: Date) -> [RealmDiaryEntry] {
        let dateString = dateFormatter.string(from: date)
        return Array(realm.objects(RealmDiaryEntry.self).filter("createDate == %@", dateString))
    }
}
