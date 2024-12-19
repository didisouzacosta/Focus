//
//  FocusPlanTests.swift
//  FocusCoreTests
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import XCTest
import FamilyControls

@testable import FocusCore

final class FocusPlanTests: XCTestCase {
    
    func testIDConsistency() {
        let focusPlan = FocusPlan(
            "Meditation Time",
            start: .now,
            end: .now,
            daysOfWeek: .all
        )
        
        XCTAssertEqual(focusPlan.id, focusPlan.activityName.rawValue)
    }
    
    func testRoundStartAndEndMinute() {
        let focusPlan = FocusPlan(
            "Focus",
            start: .from(hour: 11, minute: 43, second: 44)!,
            end: .from(hour: 12, minute: 33, second: 22)!,
            daysOfWeek: .all
        )
        
        XCTAssertEqual(focusPlan.start.hour, 11)
        XCTAssertEqual(focusPlan.start.minute, 45)
        XCTAssertEqual(focusPlan.start.second, 0)
        
        XCTAssertEqual(focusPlan.end.hour, 12)
        XCTAssertEqual(focusPlan.end.minute, 30)
        XCTAssertEqual(focusPlan.end.second, 0)
        
        let workoutPlan = FocusPlan(
            "Workout",
            start: .from(hour: 11, minute: 55, second: 44)!,
            end: .from(hour: 12, minute: 39, second: 22)!,
            daysOfWeek: .all
        )
        
        XCTAssertEqual(workoutPlan.start.hour, 12)
        XCTAssertEqual(workoutPlan.start.minute, 0)
        XCTAssertEqual(workoutPlan.start.second, 0)
        
        XCTAssertEqual(workoutPlan.end.hour, 12)
        XCTAssertEqual(workoutPlan.end.minute, 45)
        XCTAssertEqual(workoutPlan.end.second, 0)
    }
    
}
