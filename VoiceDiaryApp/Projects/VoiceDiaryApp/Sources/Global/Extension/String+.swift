//
//  String+.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/31/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
