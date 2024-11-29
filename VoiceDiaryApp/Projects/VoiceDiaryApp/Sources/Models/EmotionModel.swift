//
//  EmotionModel.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 11/29/24.
//

import Foundation

enum Emotion: String, Codable {
    case angry = "angry_face.png"
    case happy = "happy_face.png"
    case neutral = "neutral_face.png"
    case sad = "sad_face.png"
    case smiling = "smiling_face.png"
    case tired = "tired_face.png"
}

struct DiaryEntry: Codable {
    let date: Date
    let emotion: Emotion
    let content: String
}
