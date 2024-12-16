//
//  UIButton+.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 11/29/24.
//

import UIKit
import Combine

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
