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
    
    var textStyle: UIFont.TextStyle {
        switch self {
        case .PretandardBold, .RobotobBold: return .title1
        case .PretandardSemiBold: return .title2
        case .PretandardMedium: return .title3
        case .PretandardRegular, .RobotoRegular: return .caption1
        case .GangwonEduSaeeum: return .title1
        }
    }
}

extension UIFont {
    
    static func fontGuide(type: FontType, size: CGFloat) -> UIFont {
        let font = UIFont(name: type.rawValue, size: UIFont.preferredFont(forTextStyle: type.textStyle).pointSize)!
        return font
    }
}
