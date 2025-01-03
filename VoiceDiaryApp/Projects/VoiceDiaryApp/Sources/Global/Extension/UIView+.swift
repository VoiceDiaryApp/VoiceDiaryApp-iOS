//
//  UIView+.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/25/24.
//

import UIKit

import Combine

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: rect ?? bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
    
    func tapGesturePublisher() -> Publishers.Throttle<UITapGestureRecognizer.GesturePublisher<UITapGestureRecognizer>, RunLoop> {
        return UITapGestureRecognizer.GesturePublisher(recognizer: .init(), view: self)
            .throttle(
                for: .seconds(1),
                scheduler: RunLoop.main,
                latest: false
            )
    }
}
