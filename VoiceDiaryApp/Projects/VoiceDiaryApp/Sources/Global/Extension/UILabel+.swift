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
    
    func setOutline(outlineColor: UIColor, outlineWidth: CGFloat) {
        guard let currentText = self.text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: outlineColor,
            .strokeWidth: -outlineWidth,
            .foregroundColor: self.textColor ?? .black,
            .font: self.font ?? UIFont.systemFont(ofSize: 17)
        ]
        
        let attributedString = NSAttributedString(string: currentText, attributes: attributes)
        self.attributedText = attributedString
    }
}
