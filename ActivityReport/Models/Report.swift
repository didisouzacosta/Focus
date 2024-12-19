//
//  Report.swift
//  ActivityReport
//
//  Created by Adriano Souza Costa on 19/08/24.
//

import Foundation

struct ReportSegment: Hashable, Identifiable {
    
    let interval: DateInterval
    let apps: [AppDeviceActivity]
    
    var id: Int {
        interval.start.hour
    }
    
    init(_ interval: DateInterval, apps: [AppDeviceActivity]) {
        self.interval = interval
        self.apps = apps
    }
    
}

struct Report {
    
    let segments: [ReportSegment]
    
    init(_ segments: [ReportSegment]) {
        self.segments = segments
    }
    
}

extension Report {
    
    var apps: [AppDeviceActivity] {
        segments.flatMap { $0.apps }.merged()
    }
    
    var totalDuration: TimeInterval {
        segments.flatMap { $0.apps }.totalDuration
    }
    
    var totalNotifications: Int {
        segments.flatMap { $0.apps }.totalNotifications
    }
    
    var totalPickups: Int {
        segments.flatMap { $0.apps }.totalPickups
    }
    
}

extension [AppDeviceActivity] {
    
    func merged() -> Self {
        reduce([]) { current, app in
            if let index = current.firstIndex(where: { $0.bundle == app.bundle }) {
                var collection = current
                collection[index] = current[index] + app
                return collection
            } else {
                return current + [app]
            }
        }
    }
    
    var totalDuration: TimeInterval {
        merged().reduce(0) { $0 + $1.duration }
    }
    
    var totalNotifications: Int {
        merged().reduce(0) { $0 + $1.notifications }
    }
    
    var totalPickups: Int {
        merged().reduce(0) { $0 + $1.pickups }
    }
    
}
