//
//  String+.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/31/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        return Date.sharedFormatter.date(from: self)
    }
}
