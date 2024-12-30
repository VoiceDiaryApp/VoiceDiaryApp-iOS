//
//  Date+.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import Foundation

extension Date {
    
    func toLocalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    func toUTC() -> Date {
        let timeZone = TimeZone.current
        let seconds = -TimeInterval(timeZone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func dateToString() -> String {
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = koreanTimeZone
        return formatter.string(from: self)
    }
}
