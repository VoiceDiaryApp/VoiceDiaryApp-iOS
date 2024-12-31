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
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                print("😳😳oldSchemaVersion😳😳")
                print(oldSchemaVersion)
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
        self.realm = try! Realm()
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
        do {
            let realm = try Realm()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayString = dateFormatter.string(from: Date())
            
            if let entry = realm.objects(RealmDiaryEntry.self).filter("createDate == %@", todayString).first {
                return true
            } else {
                print("오늘 날짜의 엔트리가 없습니다.")
                return false
            }
        } catch {
            print("Realm 오류: \(error)")
            return false
        }
    }

//    func fetchDiaryEntry(for date: Date) -> CalendarEntry? {
//        let utcDate = date.toUTC()
//        let results = realm.objects(RealmDiaryEntry.self).filter("date == %@", utcDate)
//        return results.first?.toDiaryEntry()
//    }
//
//    func fetchAllDiaryEntries() -> [CalendarEntry] {
//        return realm.objects(RealmDiaryEntry.self).map { $0.toDiaryEntry() }
//    }
}
