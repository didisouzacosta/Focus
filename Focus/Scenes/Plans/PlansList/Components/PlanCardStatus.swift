//
//  PlanCardStatus.swift
//  Focus
//
//  Created by Adriano Souza Costa on 16/07/24.
//

import Foundation
import SwiftUI

enum PlanCardStatus: String, Identifiable {
    case running
    case next
    case standby
    case disabled
    
    var id: PlanCardStatus {
        self
    }
}
