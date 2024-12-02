//
//  SizeLiterals.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/26/24.
//

import UIKit
   
struct SizeLiterals {
    
    struct Screen {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let screenHeight: CGFloat = UIScreen.main.bounds.height
        static let deviceRatio: CGFloat = screenWidth / screenHeight
    }
    
    static func calSupporWidth(width: CGFloat) -> CGFloat {
        return width * Screen.screenWidth / 375
    }
    
    static func calSupporHeight(height: CGFloat) -> CGFloat {
        return height * Screen.screenHeight / 812
    }
}
