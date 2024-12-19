//
//  FocusPlanStore.swift
//  Focus
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import Foundation
import FocusCore
import ManagedSettings

@Observable
class FocusPlanStore {
    
    // MARK: - Public Variables
    
    var runningPlans: [FocusPlan] {
        sharedData.runningPlans()
    }
    
    var nextPlans: [FocusPlan] {
        sharedData.nextPlans()
    }
    
    var standByPlans: [FocusPlan] {
        sharedData.standByPlans()
    }
    
    var disabledPlans: [FocusPlan] {
        sharedData.disabledPlans()
    }
    
    var hasPlans: Bool {
        !sharedData.plans.isEmpty
    }
    
    var monitoredApplicationTokens: Set<ApplicationToken> {
        Set(sharedData.plans.flatMap { $0.restrictions.applicationTokens })
    }
    
    var monitoredCategoryTokens: Set<ActivityCategoryToken> {
        Set(sharedData.plans.flatMap { $0.restrictions.categoryTokens })
    }
    
    // MARK: - Private Variables

    private let sharedData: SharedData
    private let activityManager: ActivityManager
    
    // MARK: - Public Methods
    
    init(_ sharedData: SharedData, setingsStore: ManagedSettingsStore) {
        self.sharedData = sharedData
        self.activityManager = .init(sharedData: sharedData, settingsStore: setingsStore)
    }
    
    func insert(_ plan: FocusPlan) throws {
        sharedData.plans.insert(plan, at: 0)
        try activityManager.startMonitoring(plan)
    }
    
    func remove(_ plan: FocusPlan) {
        sharedData.plans.removeAll { $0.id == plan.id }
        activityManager.stopMonitoring(plan)
    }
    
    func update(_ plan: FocusPlan) throws {
        guard let index = sharedData.plans.firstIndex(where: { $0.id == plan.id }) else { return }
        remove(plan)
        sharedData.plans.insert(plan, at: index)
        try activityManager.startMonitoring(plan)
    }
    
}


