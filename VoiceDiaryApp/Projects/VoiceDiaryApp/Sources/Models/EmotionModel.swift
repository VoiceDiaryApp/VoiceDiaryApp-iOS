//
//  EmotionModel.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import Foundation

enum Emotion: String, Codable {
    case angry = "angry_face"
    case happy = "happy_face"
    case neutral = "neutral_face"
    case sad = "sad_face"
    case smiling = "smiling_face"
    case tired = "tired_face"
}

struct DiaryEntry: Codable {
    let date: Date
    var emotion: Emotion
    var content: String
}
