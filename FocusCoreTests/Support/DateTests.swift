//
//  DateTests.swift
//  FocusCoreTests
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import XCTest

@testable import FocusCore

final class DateTests: XCTestCase {
    
    func testEnsureSecondsEraser() {
        let calendar = Calendar.current
        
        let birth = Date.from(
            year: 2024,
            month: 3,
            day: 5,
            hour: 8,
            minute: 50
        )
        
        let date = birth?.hourMinute(calendar)
        
        XCTAssertEqual(date?.year, 1)
        XCTAssertEqual(date?.month, 1)
        XCTAssertEqual(date?.day, 1)
        XCTAssertEqual(date?.hour, 8)
        XCTAssertEqual(date?.minute, 50)
        XCTAssertEqual(date?.second, 0)
    }
    
    func testEnsureDateCreation() {
        let date = Date.from(
            year: 2024,
            month: 3,
            day: 5,
            hour: 8,
            minute: 50
        )
        
        XCTAssertEqual(date?.year, 2024)
        XCTAssertEqual(date?.month, 3)
        XCTAssertEqual(date?.day, 5)
        XCTAssertEqual(date?.hour, 8)
        XCTAssertEqual(date?.minute, 50)
        XCTAssertEqual(date?.second, 0)
    }
    
    func testEnsureConsistencyOfHourMinute() {
        let date = Date.from(
            year: 2024,
            month: 3,
            day: 5,
            hour: 8,
            minute: 43
        )
        
        let time = date?.hourMinute()
        
        XCTAssertEqual(time?.year, 1)
        XCTAssertEqual(time?.month, 1)
        XCTAssertEqual(time?.day, 1)
        XCTAssertEqual(time?.hour, 8)
        XCTAssertEqual(time?.minute, 43)
        XCTAssertEqual(time?.second, 0)
    }
    
    func testEnsureConsistencyOfRoundedTimeByMinute() {
        let date = Date.from(
            year: 2024,
            month: 3,
            day: 5,
            hour: 8,
            minute: 43,
            second: 3
        )
        
        let time = date?.rounded(component: .minute)
        
        XCTAssertEqual(time?.year, 2024)
        XCTAssertEqual(time?.month, 3)
        XCTAssertEqual(time?.day, 5)
        XCTAssertEqual(time?.hour, 8)
        XCTAssertEqual(time?.minute, 45)
    }
    
    func testEnsureConsistencyOfNormalizedDate() {
        let start = Date.from(
            hour: 8,
            minute: 43,
            second: 3
        )!.normalized()
        
        XCTAssertEqual(start.year, 1)
        XCTAssertEqual(start.month, 1)
        XCTAssertEqual(start.day, 1)
        XCTAssertEqual(start.hour, 8)
        XCTAssertEqual(start.minute, 45)
        XCTAssertEqual(start.second, 0)
    }
    
    func testOnlyHourAndMinuteShouldBeConsideredWhenComparingTwoNormalizedDates() {
        let start = Date.from(
            year: 2026,
            month: 10,
            day: 28,
            hour: 8,
            minute: 43,
            second: 3
        )!.normalized()
        
        let end = Date.from(
            year: 2025,
            month: 11,
            day: 1,
            hour: 12,
            minute: 2,
            second: 33
        )!.normalized()
        
        XCTAssertTrue(start < end)
    }
    
}
