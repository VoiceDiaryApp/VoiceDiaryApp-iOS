//
//  NotificationManager.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func scheduleDailyNotification(time: String) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "📓 일기 작성 시간이에요!"
        content.body = "오늘의 하루를 기록해보세요."
        content.sound = .default
        
        let timeComponents = time.split(separator: ":").map { Int($0) ?? 0 }
        var dateComponents = DateComponents()
        dateComponents.hour = timeComponents[0]
        dateComponents.minute = timeComponents[1]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
    }
}
