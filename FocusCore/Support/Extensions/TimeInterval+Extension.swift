//
//  TimeInterval+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 23/08/24.
//

import Foundation

public extension TimeInterval {
    
    func timeFormatter(maximumUnitCount: Int = 2) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.maximumUnitCount = maximumUnitCount
        return formatter.string(from: self) ?? "---"
    }
    
    var seconds: Int {
        Int(self) % 60
    }
    
    var minutes: Int {
        (Int(self) / 60) % 60
    }
    
    var hours: Int {
        Int(self) / 3600
    }
    
}
