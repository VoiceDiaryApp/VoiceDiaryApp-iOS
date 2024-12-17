//
//  UILabel+.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/17/24.
//

import UIKit

extension UILabel {
    
    func asLineHeight(_ lineHeight: CGFloat) {
        
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
