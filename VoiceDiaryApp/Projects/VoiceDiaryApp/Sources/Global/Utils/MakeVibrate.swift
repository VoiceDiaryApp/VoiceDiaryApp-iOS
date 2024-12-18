//
//  MakeVibrate.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/18/24.
//

import UIKit

extension UIViewController {
    public func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}

extension UIView {
    public func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}
