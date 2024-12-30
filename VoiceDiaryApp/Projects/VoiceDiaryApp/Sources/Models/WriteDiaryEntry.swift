//
//  WriteDiaryEntry.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/27/24.
//


struct WriteDiaryEntry: Codable {
    let date: String
    let emotion: Emotion
    let content: String
    let shortContent: String
    let title: String
    let answer: String
    let drawImage: String
}
