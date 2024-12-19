//
//  SharedData.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 09/07/24.
//

import Foundation
import Combine
import SwiftUI
import FamilyControls

enum Key: String, CaseIterable {
    case familyControlsMember,
         screenTimeIsAllowed,
         plans,
         activities
}

@Observable
public class SharedData: NSObject {
    
    // MARK: - Public Variables
    
    public static let shared = SharedData()
    
    public var familyControlsMember: FamilyControlsMember? {
        didSet { defaults.set(familyControlsMember, key: Key.familyControlsMember.rawValue) }
    }
    
    public var screenTimeIsAllowed = false  {
        didSet { defaults.set(screenTimeIsAllowed, key: Key.screenTimeIsAllowed.rawValue) }
    }
    
    public var plans = [FocusPlan]() {
        didSet { defaults.set(plans, key: Key.plans.rawValue) }
    }
    
    public var activities = Set<String>() {
        didSet { defaults.set(activities, key: Key.activities.rawValue) }
    }
    
    // MARK: - Private Variables
    
    private let defaults: UserDefaults
    
    // MARK: - Life Cicle
    
    public init(defaults: UserDefaults = .shared) {
        self.defaults = defaults
        super.init()
        populate()
        registerObservers()
    }
    
    deinit {
        unregisterObservers()
    }
    
    // MARK: - Public Methods
    
    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if
            let keyPath,
            let value = change?[.newKey],
            let key = Key(rawValue: keyPath)
        {
            apply(value, at: key)
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }
    
    public func clear() {
        defaults.dictionaryRepresentation().keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    // MARK: - Private Methods
    
    private func apply(_ value: Any, at key: Key) {
        switch key {
        case .familyControlsMember: familyControlsMember = decode(value)
        case .screenTimeIsAllowed: screenTimeIsAllowed = decode(value) ?? false
        case .plans: plans = decode(value) ?? []
        case .activities: activities = decode(value) ?? []
        }
    }
    
    private func decode<T: Decodable>(_ value: Any) -> T? {
        guard let data = value as? Data else {
            return value as? T
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    private func registerObservers() {
        Key.allCases.forEach { key in
            defaults.addObserver(
                self,
                forKeyPath: key.rawValue,
                options: [.new],
                context: nil
            )
        }
    }
    
    private func unregisterObservers() {
        Key.allCases.forEach { key in
            defaults.removeObserver(
                self,
                forKeyPath: key.rawValue
            )
        }
    }
    
    private func populate() {
        familyControlsMember = defaults.get(Key.familyControlsMember.rawValue)
        screenTimeIsAllowed = defaults.get(Key.screenTimeIsAllowed.rawValue) ?? false
        plans = defaults.get(Key.plans.rawValue) ?? []
        activities = defaults.get(Key.activities.rawValue) ?? []
    }
    
}
