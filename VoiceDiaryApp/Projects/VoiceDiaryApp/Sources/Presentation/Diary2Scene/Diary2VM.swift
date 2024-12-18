//
//  Diary2VM.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/17/24.
//

import Foundation
import Combine

final class Diary2VM {
    
    @Published var diaryTitle: String = ""
    
    init() {}

    func saveDiary() {
        print("Diary saved with title: \(diaryTitle)")
    }
}
