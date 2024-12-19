//
//  SharedData+Extension.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 25/07/24.
//

import Foundation

public extension SharedData {
    
    static let test = SharedData(defaults: .test)
    
    func runningPlans(at dayOfWeek: DayOfWeek = .currentDay) -> [FocusPlan] {
        plans.enabledPlans.filter {
            $0.daysOfWeek.contains(dayOfWeek) && activities.contains($0.activityName.rawValue)
        }.sorted {
            ($0.start, $0.title.lowercased()) < ($1.start, $1.title.lowercased())
        }
    }
    
    func nextPlans(at dayOfWeek: DayOfWeek = .currentDay, time: Date = .now) -> [FocusPlan] {
        plans.enabledPlans.filter {
            $0.daysOfWeek.contains(dayOfWeek) && !activities.contains($0.activityName.rawValue) &&
            $0.start >= time.normalized()
        }.sorted {
            ($0.start, $0.title.lowercased()) < ($1.start, $1.title.lowercased())
        }
    }
    
    func standByPlans(at dayOfWeek: DayOfWeek = .currentDay, time: Date = .now) -> [FocusPlan] {
        let activePlans = runningPlans(at: dayOfWeek) + nextPlans(at: dayOfWeek, time: time)
        let standByPlans = plans.enabledPlans.filter { !activePlans.contains($0) }
        return standByPlans.sorted(by: dayOfWeek)
    }
    
    func disabledPlans(at dayOfWeek: DayOfWeek = .currentDay) -> [FocusPlan] {
        plans.disabledPlans.sorted(by: dayOfWeek)
    }
    
}

fileprivate extension [FocusPlan] {
    
    var enabledPlans: Self {
        filter { $0.enabled }
    }
     
    var disabledPlans: Self {
        filter { !$0.enabled }
    }
    
    func sorted(by dayOfWeek: DayOfWeek) -> Self {
        let nextPlans = filter {
            $0.daysOfWeek.nextDay(from: dayOfWeek) > dayOfWeek
        }.sorted {
            ($0.daysOfWeek.nextDay(from: dayOfWeek), $0.start, $0.title.lowercased()) < ($1.daysOfWeek.nextDay(from: dayOfWeek), $1.start, $1.title.lowercased())
        }
        
        let previousPlans = filter {
            $0.daysOfWeek.nextDay(from: dayOfWeek) <= dayOfWeek
        }.sorted {
            ($0.daysOfWeek.nextDay(from: dayOfWeek), $0.start, $0.title.lowercased()) < ($1.daysOfWeek.nextDay(from: dayOfWeek), $1.start, $1.title.lowercased())
        }
        
        return nextPlans + previousPlans
    }
    
}
