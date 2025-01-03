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
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 권한 요청 실패: \(error.localizedDescription)")
                }
                UserManager.shared.updateSetNotification(set: granted)
                completion(granted)
            }
        }
    }
    
    func scheduleDailyNotification(time: String) {
        guard let timeComponents = parseTimeString(time) else {
            print("잘못된 시간 형식")
            return
        }
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "📓 일기 작성 시간이에요!"
        content.body = "오늘의 하루를 기록해보세요."
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                print("알림 스케줄링 성공")
            }
        }
    }
    
    private func parseTimeString(_ time: String) -> DateComponents? {
        let components = time.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return nil }
        return DateComponents(hour: components[0], minute: components[1])
    }
    
    func isNotificationAuthorized(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
}
