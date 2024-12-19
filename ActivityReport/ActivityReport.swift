//
//  ActivityReport.swift
//  ActivityReport
//
//  Created by Adriano Souza Costa on 11/08/24.
//

import DeviceActivity
import SwiftUI

@main
struct ActivityReport: DeviceActivityReportExtension {
    
    var body: some DeviceActivityReportScene {
        UsageActivityReport { usageActivity in
            UsageActivityReportView(usageActivity)
        }
    }
    
}
