//
//  UIView+.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/25/24.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
