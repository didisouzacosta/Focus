//
//  Settings.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 14/08/24.
//

import Foundation

public final class Settings {
    
    // MARK: - Public Properties
    
    public static let shared = Settings()
    
    public var onboardIsCompleted: Bool {
        get { userDefaults.get("onboardIsCompleted") ?? false }
        set { userDefaults.set(newValue, key: "onboardIsCompleted") }
    }
    
    // MARK: - Private Properties
    
    private let userDefaults: UserDefaults = .settings
    
    // MARK: - Life Cicle
    
    public init() {}
    
}
