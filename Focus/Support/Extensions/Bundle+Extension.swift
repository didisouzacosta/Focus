//
//  Bundle+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 15/08/24.
//

import Foundation

extension Bundle {
    
    var appName: String {
        object(forInfoDictionaryKey: "CFBundleName") as? String ?? "---"
    }
    
    var displayName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "---"
    }
    
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "---"
    }
    
    var buildNumber: String {
        object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "---"
    }
    
}
