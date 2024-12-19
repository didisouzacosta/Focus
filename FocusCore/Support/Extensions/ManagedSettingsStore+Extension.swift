//
//  ManagedSettingsStore+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 12/08/24.
//

import ManagedSettings

public extension ManagedSettingsStore {
    
    static let shared = ManagedSettingsStore(named: .init(rawValue: "focus.shared"))
    static let preview = ManagedSettingsStore(named: .init(rawValue: "focus.preview"))
    static let test = ManagedSettingsStore(named: .init(rawValue: "focus.test"))
    
}
