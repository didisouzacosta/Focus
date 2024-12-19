//
//  DayOfWeek+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 12/07/24.
//

import Foundation

public extension DayOfWeek {
    
    static var currentDay: DayOfWeek {
        let weekDay = Date.now.components([.weekday]).weekday ?? 1
        return DayOfWeek(rawValue: weekDay) ?? .sunday
    }
    
    static var weekdays: [DayOfWeek] {
        [.monday, .tuesday, .wednesday, .thursday, .friday]
    }
    
    static var weekend: [DayOfWeek] {
        [.saturday, .sunday]
    }
    
    static var all: [DayOfWeek] {
        [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }
    
    var nextDay: DayOfWeek {
        .init(rawValue: rawValue + 1) ?? .sunday
    }
    
    var abbr: String {
        switch self {
        case .sunday: "sun"
        case .monday: "mon"
        case .tuesday: "tue"
        case .wednesday: "wed"
        case .thursday: "thu"
        case .friday: "fri"
        case .saturday: "sat"
        }
    }
    
    var name: String {
        switch self {
        case .sunday: "sunday"
        case .monday: "monday"
        case .tuesday: "tuesday"
        case .wednesday: "wednesday"
        case .thursday: "thursday"
        case .friday: "friday"
        case .saturday: "saturday"
        }
    }
    
}

extension DayOfWeek: Comparable, Equatable {
    
    public static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}

public extension [DayOfWeek] {
    
    static var weekdays: Self {
        DayOfWeek.weekdays
    }
    
    static var weekend: Self {
        DayOfWeek.weekend
    }
    
    static var all: Self {
        DayOfWeek.all
    }
    
    var mostDay: DayOfWeek {
        sorted().last ?? .sunday
    }
    
    var minorDay: DayOfWeek {
        sorted().first ?? .sunday
    }
    
    func nextDay(from day: DayOfWeek = .currentDay) -> DayOfWeek {
        filter { $0 > day }.sorted().first ?? first ?? .sunday
    }
    
    func previousDay(from day: DayOfWeek = .currentDay) -> DayOfWeek {
        filter { $0 < day }.sorted().first ?? first ?? .sunday
    }
    
}
