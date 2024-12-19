//
//  ActivityManager.swift
//  Focus
//
//  Created by Adriano Souza Costa on 05/07/24.
//

import Foundation
import SwiftUI
import ManagedSettings
import DeviceActivity

@Observable
public class ActivityManager {
    
    // MARK: - Public Variables
    
    public static let shared = ActivityManager(sharedData: .shared, settingsStore: .shared)
    
    public var plans: [FocusPlan] {
        sharedData.plans
    }
    
    // MARK: - Private Variables
    
    private let sharedData: SharedData
    private let settingsStore: ManagedSettingsStore
    private let deviceActivityCenter = DeviceActivityCenter()
    
    private var timer: Timer?
    
    // MARK: - Public Methods
    
    public init(sharedData: SharedData, settingsStore: ManagedSettingsStore) {
        self.sharedData = sharedData
        self.settingsStore = settingsStore
    }
    
    public func intervalStart(for activity: DeviceActivityName) {
        sharedData.activities.insert(activity.rawValue)
        applyRestrictions()
    }
    
    public func intervalEnd(for activity: DeviceActivityName) {
        sharedData.activities.remove(activity.rawValue)
        applyRestrictions()
    }
    
    public func startMonitoring(_ plan: FocusPlan) throws { 
        #if !targetEnvironment(simulator)
        let schedule = DeviceActivitySchedule(
            intervalStart: .init(hour: plan.start.hour, minute: plan.start.minute),
            intervalEnd: .init(hour: plan.end.hour, minute: plan.end.minute),
            repeats: true
        )
        
        try deviceActivityCenter.startMonitoring(plan.activityName, during: schedule)
        #endif
    }
    
    public func stopMonitoring(_ plan: FocusPlan) {
        #if !targetEnvironment(simulator)
        deviceActivityCenter.stopMonitoring([plan.activityName])
        #endif
        
        intervalEnd(for: plan.activityName)
    }
    
    // MARK: - Private Methods
    
    private func applyRestrictions() {
        let activePlans = sharedData.runningPlans()
        let applicationTokens = Set(activePlans.flatMap { $0.restrictions.applicationTokens })
        let categoryTokens = Set(activePlans.flatMap { $0.restrictions.categoryTokens })
        
        settingsStore.shield.applications = applicationTokens
        settingsStore.shield.applicationCategories = .specific(categoryTokens, except: [])
    }
    
}
