//
//  DeviceActivityMonitorExtension.swift
//  FocusActivityMonitor
//
//  Created by Adriano Souza Costa on 06/07/24.
//

import DeviceActivity

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    // MARK: - Private Variables
    
    private let activityManager = ActivityManager.shared
    
    // MARK: - Public Methods
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        activityManager.intervalStart(for: activity)
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        activityManager.intervalEnd(for: activity)
    }
    
}
