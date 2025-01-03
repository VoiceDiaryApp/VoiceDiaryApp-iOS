//
//  DeviceUtils.swift
//  VoiceDiaryApp
//
//  Created by ahra on 12/31/24.
//

import UIKit

struct DeviceUtils {
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
