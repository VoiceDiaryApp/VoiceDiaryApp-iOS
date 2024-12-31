//
//  UserDefaultWrapper.swift
//  VoiceDiaryApp
//
//  Created by 신호연 on 12/31/24.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
