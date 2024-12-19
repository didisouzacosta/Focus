//
//  FocusPlan+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import Foundation
import DeviceActivity

public extension FocusPlan {
    
    static var empty: Self {
        .init(
            "",
            start: .now.rounded(),
            end: .now.rounded().addingTimeInterval(15.minute),
            daysOfWeek: [.currentDay]
        )
    }
    
    static var samples: [FocusPlan] {
        [
            .init(
                "Work",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: .weekdays
            ),
            .init(
                "Workout",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: .weekdays
            ),
            .init(
                "English",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: [.thursday]
            )
        ]
    }
    
    var activityName: DeviceActivityName {
        DeviceActivityName(id)
    }
    
    var restrictionsCount: Int {
        restrictions.applicationTokens.count + restrictions.categoryTokens.count
    }
    
}

public extension [FocusPlan] {
    
    static var samples: Self {
        FocusPlan.samples
    }
    
}
