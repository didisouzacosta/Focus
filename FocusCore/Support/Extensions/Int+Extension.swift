//
//  Int+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 25/07/24.
//

import Foundation

public extension Int {
    
    var minute: TimeInterval {
        Double(60 * self)
    }
    
    var hour: TimeInterval {
        self.minute * 60
    }
    
}
