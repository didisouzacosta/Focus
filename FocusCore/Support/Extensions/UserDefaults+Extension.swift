//
//  UserDefaults+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 09/07/24.
//

import Foundation
import SwiftUI

public extension UserDefaults {
    
    static let shared = UserDefaults(suiteName: "group.didisouzacosta.focus.sharedData")!
    static let preview = UserDefaults(suiteName: "group.preview.focus")!
    static let settings = UserDefaults(suiteName: "group.settings.focus")!
    static let test = UserDefaults(suiteName: "group.test.focus")!
 
    func get<T: Codable & Equatable>(
        _ key: String,
        decoder: JSONDecoder = .init()
    ) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func set<T: Codable & Equatable>(
        _ value: T?,
        key: String,
        encoder: JSONEncoder = .init()
    ) {
        guard value != get(key) else { return }
        
        if let value, let data = try? encoder.encode(value) {
            set(data, forKey: key)
        } else {
            removeObject(forKey: key)
        }
    }
    
    func clear() {
        dictionaryRepresentation().keys.forEach { key in
            removeObject(forKey: key)
        }
    }
    
}
