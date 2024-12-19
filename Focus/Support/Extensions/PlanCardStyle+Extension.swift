//
//  PlanCardStyle+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 18/07/24.
//

import Foundation
import SwiftUI

extension PlanCardStatus {
    
    var spaceBetweenCards: CGFloat {
        switch self {
        case .running: 12
        default: 4
        }
    }
    
    var internalSpacing: CGFloat {
        switch self {
        case .running: 12
        default: 8
        }
    }
    
    var isRunning: Bool {
        switch self {
        case .running: true
        default: false
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .running, .standby: true
        default: false
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .running: 1
        case .standby, .next: 0.8
        case .disabled: 0.6
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .running: 1
        default: 0.94
        }
    }
    
    var titleSize: Font {
        switch self {
        case .running: .title2
        default: .headline
        }
    }
    
    var cardActiveColor: Color {
        switch self {
        case .running: .patternActive
        default: Color(.tertiarySystemFill)
        }
    }
    
    var cardActiveTextColor: Color {
        switch self {
        case .running: .white
        default: .patternText
        }
    }
    
}
