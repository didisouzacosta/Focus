//
//  FocusPlan.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import Foundation
import FamilyControls

public struct FocusPlan: Codable, Equatable, Identifiable {
    
    public let id: String
    
    public var title: String
    public var daysOfWeek: [DayOfWeek]
    public var restrictions: FamilyActivitySelection
    public var enabled: Bool
    
    public var start: Date {
        get { _start }
        set { _start = newValue.normalized() }
    }
    
    public var end: Date {
        get { _end }
        set { _end = newValue.normalized() }
    }
    
    private var _start: Date
    private var _end: Date
    
    public init(
        _ title: String,
        start: Date,
        end: Date,
        daysOfWeek: [DayOfWeek],
        restrictions: FamilyActivitySelection = .init(),
        enabled: Bool = true
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.daysOfWeek = daysOfWeek
        self.restrictions = restrictions
        self.enabled = enabled
        
        _start = start.normalized()
        _end = end.normalized()
    }
    
}
