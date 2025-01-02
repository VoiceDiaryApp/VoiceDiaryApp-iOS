//
//  UserManager.swift
//  VoiceDiaryApp
//
//  Created by ahra on 1/2/25.
//

final class UserManager {
    
    static let shared = UserManager()
    private let realmManager = RealmDiaryManager()
    
    @UserDefaultWrapper(key: "isNotificationSet", defaultValue: false) private(set) var isNotificationSet: Bool
    @UserDefaultWrapper(key: "dailyNotificationTime", defaultValue: "") private(set) var dailyNotificationTime: String
    
    var getSetNotification: Bool { return self.isNotificationSet }
    var getNotificationTime: String { return self.dailyNotificationTime}
    
    private init() {}
}

extension UserManager {
    
    func updateSetNotification(set: Bool) {
        self.isNotificationSet = set
    }
    
    func updateNotificationTime(time: String) {
        self.isNotificationSet = true
        self.dailyNotificationTime = time
    }
    
    func clearData() {
        self.isNotificationSet = false
        self.dailyNotificationTime = ""
        self.realmManager.delAllEntry()
    }
}
