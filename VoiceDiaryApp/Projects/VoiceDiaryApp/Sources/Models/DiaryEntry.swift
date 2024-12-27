//
//  DiaryEntry.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/4/24.
//

import Foundation

enum Emotion: String, Codable {
    case angry = "angry_face"
    case happy = "happy_face"
    case neutral = "neutral_face"
    case sad = "sad_face"
    case smiling = "smiling_face"
    case tired = "tired_face"
    
    var emotionToPrompt: String {
        switch self {
        case .angry:
            return "화가 나는 하루였다."
        case .happy:
            return "행복한 하루였다."
        case .neutral:
            return "평범한 하루였다."
        case .sad:
            return "슬픈 하루였다."
        case .smiling:
            return "좋은 하루였다."
        case .tired:
            return "피곤한 하루였다."
        }
    }
}

struct DiaryEntry: Codable {
    let date: Date
    var emotion: Emotion
    var content: String
}
