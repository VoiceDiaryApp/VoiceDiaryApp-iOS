//
//  AppDelegate.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/22/24.
//

import Foundation
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = UINavigationController(rootViewController: SplashVC())
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window

        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                if let savedTime = UserDefaults.standard.string(forKey: "dailyNotificationTime") {
                    NotificationManager.shared.scheduleDailyNotification(time: savedTime)
                }
            } else {
                print("알림 권한이 허용되지 않았습니다.")
            }
        }

        return true
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if !granted { }
        }
    }
}
