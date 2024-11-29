//
//  AppDelegate.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/22/24.
//

import Foundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application( 
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = DiaryViewController(viewModel: DiaryViewModel())
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
