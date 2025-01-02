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
    case GangwonEduSaeeum = "GangwonEduSaeeum"
}

extension UIFont {
    
    static func fontGuide(type: FontType, size: CGFloat) -> UIFont {
        let font = UIFont(name: type.rawValue, size: size)!
        for family in UIFont.familyNames {
            print("Font family: \(family)")
            let fontNames = UIFont.fontNames(forFamilyName: family)
            for fontName in fontNames {
                print("    \(fontName)")
            }
        }
        return font
    }
}
