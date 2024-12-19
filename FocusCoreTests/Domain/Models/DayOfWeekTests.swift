//
//  DayOfWeekTests.swift
//  FocusCoreTests
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import XCTest

@testable import FocusCore

final class DayOfWeekTests: XCTestCase {
    
    func testEnsureCurrentDayConsistency() {
        let weekday = Date.now.weekday
        let currentDay = DayOfWeek.currentDay
        
        XCTAssertEqual(weekday, currentDay.rawValue)
    }
    
    func testEnsureSortConsistency() {
        let days = DayOfWeek.all.sorted()
        XCTAssertEqual(days, [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    }
    
    func testEnsureWeekDaysConsistency() {
        XCTAssertEqual(DayOfWeek.weekdays, [.monday, .tuesday, .wednesday, .thursday, .friday])
    }
    
    func testEnsureWeekendConsistency() {
        XCTAssertEqual(DayOfWeek.weekend, [.saturday, .sunday])
    }
    
    func testEnsureCompareConsistency() {
        XCTAssertTrue(DayOfWeek.sunday < DayOfWeek.monday)
        XCTAssertTrue(DayOfWeek.monday < DayOfWeek.tuesday)
        XCTAssertTrue(DayOfWeek.tuesday < DayOfWeek.wednesday)
        XCTAssertTrue(DayOfWeek.wednesday < DayOfWeek.thursday)
        XCTAssertTrue(DayOfWeek.thursday < DayOfWeek.friday)
        XCTAssertTrue(DayOfWeek.friday < DayOfWeek.saturday)
        XCTAssertTrue(DayOfWeek.saturday > DayOfWeek.sunday)
    }
    
    func testEnsureNextDayConsistency() {
        XCTAssertEqual(DayOfWeek.sunday.nextDay, .monday)
        XCTAssertEqual(DayOfWeek.monday.nextDay, .tuesday)
        XCTAssertEqual(DayOfWeek.tuesday.nextDay, .wednesday)
        XCTAssertEqual(DayOfWeek.wednesday.nextDay, .thursday)
        XCTAssertEqual(DayOfWeek.thursday.nextDay, .friday)
        XCTAssertEqual(DayOfWeek.friday.nextDay, .saturday)
        XCTAssertEqual(DayOfWeek.saturday.nextDay, .sunday)
    }
    
    func testEnsureMostDayConsistency() {
        let days: [DayOfWeek] = [
            .saturday,
            .sunday,
            .monday,
            .friday
        ]
        
        XCTAssertEqual(days.mostDay, .saturday)
    }
    
    func testEnsureCollectionNextDayConsistency() {
        let days: [DayOfWeek] = .all
        
        XCTAssertEqual(days.nextDay(from: .monday), .tuesday)
        
        let emptyDays: [DayOfWeek] = []
        
        XCTAssertEqual(emptyDays.nextDay(from: .sunday), .sunday)
    }
    
}
