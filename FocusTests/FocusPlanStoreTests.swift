//
//  FocusPlanStoreTests.swift
//  FocusCoreTests
//
//  Created by Adriano Souza Costa on 09/08/24.
//

import XCTest
import SwiftUI
import FocusCore

@testable import Focus

final class FocusPlanStoreTests: XCTestCase {
    
    private let store = FocusPlanStore(.test, setingsStore: .test)
    private lazy var sharedData: SharedData = .test
    
    override func setUp() {
        super.setUp()
        UserDefaults.test?.clear()
    }
    
    func testEnsureConsistencyOfHasPlansProperty() throws {
        XCTAssertFalse(store.hasPlans)
        
        try store.insert(.samples[0])
        
        XCTAssertTrue(store.hasPlans)
    }
    
    func testMustInsertPlan() throws {
        let plan = FocusPlan(
            "Test Plan",
            start: .now,
            end: .now.addingTimeInterval(15.minute),
            daysOfWeek: .all
        )
        
        try store.insert(plan)
        
        sharedData.activities.insert(plan.activityName.rawValue)
        
        XCTAssertEqual(store.runningPlans.count, 1)
        XCTAssertEqual(store.runningPlans.first?.title, "Test Plan")
    }
    
    func testMustRemovePlan() throws {
        let plan = FocusPlan(
            "Test Plan",
            start: .now,
            end: .now.addingTimeInterval(15.minute),
            daysOfWeek: .all
        )
        
        try store.insert(plan)
        
        sharedData.activities.insert(plan.activityName.rawValue)
        
        XCTAssertEqual(store.runningPlans.first?.title, "Test Plan")
        
        store.remove(plan)
        
        XCTAssertTrue(store.runningPlans.isEmpty)
    }
    
    func testMustUpdatePlan() throws {
        let plan = FocusPlan(
            "Test Plan",
            start: .now,
            end: .now.addingTimeInterval(15.minute),
            daysOfWeek: .all
        )
        
        try store.insert(plan)
        
        sharedData.activities.insert(plan.activityName.rawValue)
        
        var updatedPlan = plan
        updatedPlan.title = "Updated Test Plan"
        
        try store.update(updatedPlan)
        
        sharedData.activities.insert(updatedPlan.activityName.rawValue)
        
        XCTAssertEqual(store.runningPlans.count, 1)
        XCTAssertEqual(store.runningPlans.first?.title, "Updated Test Plan")
    }
    
    func testDoesNotUpdateFromTheInvalidPlan() throws {
        let plan = FocusPlan(
            "Test Plan",
            start: .now,
            end: .now.addingTimeInterval(15.minute),
            daysOfWeek: .all
        )
        
        try store.insert(plan)
        
        sharedData.activities.insert(plan.activityName.rawValue)
        
        let invalidPlan = FocusPlan("", start: .now, end: .now, daysOfWeek: [])
        
        try store.update(invalidPlan)
        
        XCTAssertEqual(store.runningPlans.count, 1)
        XCTAssertTrue(store.nextPlans.isEmpty)
        XCTAssertTrue(store.standByPlans.isEmpty)
        XCTAssertTrue(store.disabledPlans.isEmpty)
        XCTAssertEqual(store.runningPlans.first?.title, "Test Plan")
    }
    
}
