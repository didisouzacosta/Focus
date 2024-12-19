//
//  Double+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 18/07/24.
//

import Foundation

public extension Double {
    
    var minute: TimeInterval {
        self * 60
    }
    
    var hour: TimeInterval {
        self * 60 * 60
    }
    
}
