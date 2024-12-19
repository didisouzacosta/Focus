//
//  AppDeviceActivity.swift
//  ActivityReport
//
//  Created by Adriano Souza Costa on 19/08/24.
//

import Foundation
import ManagedSettings
import SwiftUI

struct AppDeviceActivity {
    
    // MARK: - Public Variables
    
    let bundle: String
    let token: ApplicationToken?
    let name: String
    let duration: TimeInterval
    let notifications: Int
    let pickups: Int
    
    // MARK: - Life Cicle
    
    init(
        _ bundle: String,
        token: ApplicationToken?,
        name: String,
        duration: TimeInterval,
        notifications: Int,
        pickups: Int
    ) {
        self.bundle = bundle
        self.token = token
        self.name = name
        self.duration = duration
        self.notifications = notifications
        self.pickups = pickups
    }
    
}

extension AppDeviceActivity: Identifiable, Hashable {
    
    var id: String {
        bundle
    }
    
    static func + (lhs: AppDeviceActivity, rhs: AppDeviceActivity) -> AppDeviceActivity {
        .init(
            lhs.bundle,
            token: lhs.token,
            name: lhs.name,
            duration: lhs.duration + rhs.duration,
            notifications: lhs.notifications + rhs.notifications,
            pickups: lhs.pickups + rhs.pickups
        )
    }
    
}
