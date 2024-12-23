//
//  FontLiterals.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/26/24.
//

import UIKit

enum FontType: String {
    case PretandardBold = "Pretendard-Bold"
    case PretandardSemiBold = "Pretendard-SemiBold"
    case PretandardMedium = "Pretendard-Medium"
    case PretandardRegular = "Pretendard-Regular"
    case RobotobBold = "Roboto-Bold"
    case RobotoRegular = "Roboto-Regular"
    case NanumHand = "나눔손글씨 또박또박"
}

extension UIFont {
    
    static func fontGuide(type: FontType, size: CGFloat) -> UIFont {
        let font = UIFont(name: type.rawValue, size: size)!
        return font
    }
}
