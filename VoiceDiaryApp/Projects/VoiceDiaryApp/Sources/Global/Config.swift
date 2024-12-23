//
//  Config.swift
//  VoiceDiaryApp
//
//  Created by 고아라 on 12/19/24.
//

import Foundation

enum Config {
    
    enum Keys {
        enum Plist {
            static let apiKey = "API_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}

extension Config {
    
    // MARK: API Key
    
    static let apiKey: String = {
        guard let apiKey = Config.infoDictionary[Keys.Plist.apiKey] as? String else {
            fatalError("API Key is not set in plist for this configuration.")
        }
        return apiKey
    }()
}
