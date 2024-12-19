//
//  Date+Extension.swift
//  Focus
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import Foundation

public extension Date {
    
    var weekday: Int {
        components([.weekday]).weekday!
    }
    
    var year: Int {
        components([.year]).year!
    }
    
    var month: Int {
        components([.month]).month!
    }
    
    var day: Int {
        components([.day]).day!
    }
    
    var hour: Int {
        components([.hour]).hour!
    }
    
    var minute: Int {
        components([.minute]).minute!
    }
    
    var second: Int {
        components([.second]).second!
    }
    
    static func from(
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        calendar: Calendar = .current
    ) -> Date? {
        let components = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        
        return calendar.date(from: components)
    }
    
    func normalized(amount: Int = 15, calendar: Calendar = .current) -> Self {
        hourMinute(calendar).rounded(on: amount, component: .minute)
    }
    
    func minutesFrom(_ date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents(
            [.minute],
            from: date,
            to: self
        ).minute ?? 0
    }
    
    func hourMinute(_ calendar: Calendar = .current) -> Date {
        let dateComponents = calendar.dateComponents(
            [.hour, .minute],
            from: self
        )
        return calendar.date(from: dateComponents)!
    }
    
    func rounded(
        on amount: Int = 15,
        component: Calendar.Component = .minute
    ) -> Date {
        let cal = Calendar.current
        let value = cal.component(component, from: self)
        let roundedValue = lrint(Double(value) / Double(amount)) * amount
        let newDate = cal.date(byAdding: component, value: roundedValue - value, to: self)!
        
        return newDate.floorAllComponents(before: component)
    }
    
    func components(
        _ components: Set<Calendar.Component>, 
        calendar: Calendar = .current
    ) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    // MARK: - Private Methods
    
    fileprivate func floorAllComponents(before component: Calendar.Component) -> Date {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second, .nanosecond]

        guard let index = components.firstIndex(of: component) else {
            fatalError("Wrong component")
        }

        let cal = Calendar.current
        var date: Date?

        components.suffix(from: index + 1).forEach { roundComponent in
            let value = cal.component(roundComponent, from: self) * -1
            date = cal.date(byAdding: roundComponent, value: value, to: self)
        }

        return date ?? self
    }
    
}
