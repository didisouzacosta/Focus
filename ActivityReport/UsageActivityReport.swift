//
//  UsageActivityReport.swift
//  ActivityReport
//
//  Created by Adriano Souza Costa on 11/08/24.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    static let usageActivity = Self("Usage Activity")
}

struct UsageActivityReport: DeviceActivityReportScene {
    
    let context: DeviceActivityReport.Context = .usageActivity
    let content: (Report) -> UsageActivityReportView
    
    func makeConfiguration(
        representing data: DeviceActivityResults<DeviceActivityData>
    ) async -> Report {
        var segments = [ReportSegment]()
        
        for await eachData in data {
            for await activitySegment in eachData.activitySegments {
                
                let interval = activitySegment.dateInterval
                var apps = [AppDeviceActivity]()
                
                for await categoryActivity in activitySegment.categories {
                    for await applicationActivity in categoryActivity.applications {
                        let duration = applicationActivity.totalActivityDuration
                        let notifications = applicationActivity.numberOfNotifications
                        let pickups = applicationActivity.numberOfPickups
                        
                        if let name = applicationActivity.application.localizedDisplayName,
                           let bundle = applicationActivity.application.bundleIdentifier,
                           let token = applicationActivity.application.token
                        {
                            let appDeviceActivity = AppDeviceActivity(
                                bundle,
                                token: token,
                                name: name,
                                duration: duration,
                                notifications: notifications,
                                pickups: pickups
                            )
                            
                            apps.append(appDeviceActivity)
                        }
                    }
                }
                
                segments.append(.init(interval, apps: apps))
            }
        }
        
        return .init(segments)
    }
    
}
