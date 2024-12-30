//
//  RealmDiaryEntry.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/27/24.
//

import Foundation
import RealmSwift

final class RealmDiaryEntry: Object {
    @Persisted(primaryKey: true) var createDate: String
//    @Persisted var date: Date
    @Persisted var emotion: String
    @Persisted var content: String
    @Persisted var shortContent: String
    @Persisted var title: String
    @Persisted var answer: String
    @Persisted var drawImage: String
}
