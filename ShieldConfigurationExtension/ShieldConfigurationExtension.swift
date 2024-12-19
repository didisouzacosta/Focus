//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by Adriano Souza Costa on 02/08/24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        .commom
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        .commom
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        .commom
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        .commom
    }
    
}

extension ShieldConfiguration {
    
    static var commom: Self {
        let subtitle: String
        
        if let plan = SharedData.shared.runningPlans().first {
            subtitle = "Stay focused on your '\(plan.title)' plan.\nYou count always on the Focus app."
        } else {
            subtitle = "Focus helps you priorize your tasks and amplify your success."
        }
        
        return .init(
            backgroundBlurStyle: .dark,
            backgroundColor: .black,
            icon: .init(named: "Logo"),
            title: .init(text: "Keep focus", color: .white),
            subtitle: .init(text: subtitle, color: .white),
            primaryButtonBackgroundColor: .init(named: "patternCardActive")
        )
    }
    
}
