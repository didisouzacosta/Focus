//
//  SharedDefaultsTests.swift
//  FocusCoreTests
//
//  Created by Adriano Souza Costa on 05/07/24.
//

import XCTest
import FamilyControls

@testable import FocusCore
@testable import Focus

final class SharedDataTests: XCTestCase {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let testDefaults = UserDefaults.test
    private lazy var sharedData = SharedData(defaults: testDefaults)
    
    override func setUp() {
        super.setUp()
        sharedData.clear()
    }
    
    func testShareDatasWithDifferentUserDefaultsShouldNotMergeData() {
        let sharedData1 = SharedData(defaults: .init(suiteName: "group.test.1")!)
        let sharedData2 = SharedData(defaults: .init(suiteName: "group.test.2")!)
        
        sharedData1.screenTimeIsAllowed = true
        
        XCTAssertTrue(sharedData1.screenTimeIsAllowed)
        XCTAssertFalse(sharedData2.screenTimeIsAllowed)
        
        sharedData2.activities = ["test"]
        
        XCTAssertTrue(sharedData1.screenTimeIsAllowed)
        XCTAssertEqual(sharedData1.activities, [])
        
        XCTAssertFalse(sharedData2.screenTimeIsAllowed)
        XCTAssertEqual(sharedData2.activities, ["test"])
    }
    
    func testEnsureSyncOfFamilyControlsMemberProperty() throws {
        XCTAssertNil(sharedData.familyControlsMember)
        
        let data = try encoder.encode(FamilyControlsMember.individual)
        testDefaults.set(data, forKey: "familyControlsMember")
        
        XCTAssertEqual(sharedData.familyControlsMember, .individual)
        
        sharedData.familyControlsMember = .child
        
        let storeData = testDefaults.value(forKey: "familyControlsMember") as! Data
        let value = try decoder.decode(FamilyControlsMember.self, from: storeData)
        
        XCTAssertEqual(.child, value)
    }
    
    func testEnsureSyncOfPlansProperty() throws {
        XCTAssertEqual(sharedData.plans, [])
        
        let plans = [
            FocusPlan(
                "Test",
                start: .now,
                end: .now.addingTimeInterval(15.minute),
                daysOfWeek: []
            )
        ]
        
        let data = try encoder.encode(plans)
        
        testDefaults.set(data, forKey: "plans")
        
        XCTAssertEqual(sharedData.plans, plans)
        
        sharedData.plans = []
        
        let storeData = testDefaults.value(forKey: "plans") as! Data
        let value = try decoder.decode([FocusPlan].self, from: storeData)
        
        XCTAssertEqual(value, [])
    }
    
    func testEnsureSyncOfActivitiesProperty() throws {
        XCTAssertEqual(sharedData.activities, [])
        
        let activities: Set<String> = ["meditation"]
        let data = try encoder.encode(activities)
        testDefaults.set(data, forKey: "activities")
        
        XCTAssertEqual(sharedData.activities, activities)
        
        sharedData.activities = []
        
        let storeData = testDefaults.value(forKey: "activities") as! Data
        let value = try decoder.decode([String].self, from: storeData)
        
        XCTAssertEqual(value, [])
    }
    
    func testEnsureSyncOfIsAuthorizedProperty() throws {
        XCTAssertFalse(sharedData.screenTimeIsAllowed)
        
        testDefaults.set(true, forKey: "screenTimeIsAllowed")
        
        XCTAssertTrue(sharedData.screenTimeIsAllowed)
        
        sharedData.screenTimeIsAllowed = false
        
        XCTAssertFalse(testDefaults.bool(forKey: "screenTimeIsAllowed"))
    }
    
    func testEnsureConcistencyOfRunningPlans() throws {
        let dayOfWeek = DayOfWeek.wednesday
        
        sharedData.plans = [
            .init(
                "a",
                start: .from(hour: 11, minute: 0)!,
                end: .from(hour: 12, minute: 30)!,
                daysOfWeek: [.thursday]
            ),
            .init(
                "b",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 14, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "c",
                start: .from(hour: 7, minute: 0)!,
                end: .from(hour: 8, minute: 30)!,
                daysOfWeek: .all
            ),
            .init(
                "d",
                start: .from(hour: 7, minute: 0)!,
                end: .from(hour: 8, minute: 30)!,
                daysOfWeek: .all
            )
        ]
        
        sharedData.activities = Set(sharedData.plans.map { $0.activityName.rawValue })
        
        let runningsPlans = sharedData.runningPlans(at: dayOfWeek).map { $0.title }
        
        XCTAssertEqual(runningsPlans, ["c", "d", "b"])
    }
    
    func testEnsureConcistencyOfNextPlans() throws {
        let time = Date.from(hour: 12, minute: 0, second: 0)!
        let dayOfWeek = DayOfWeek.wednesday
        
        let plans: [FocusPlan] = [
            .init(
                "a",
                start: .from(hour: 12, minute: 0)!,
                end: .from(hour: 15, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "b",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 14, minute: 30)!,
                daysOfWeek: [.tuesday]
            ),
            .init(
                "c",
                start: .from(hour: 7, minute: 0)!,
                end: .from(hour: 8, minute: 30)!,
                daysOfWeek: .all
            ),
            .init(
                "d",
                start: .from(hour: 11, minute: 30)!,
                end: .from(hour: 15, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "e",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "f",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            )
        ]
        
        sharedData.plans = plans
        sharedData.activities = Set([plans[1], plans[2]].compactMap { $0.activityName.rawValue })
        
        let nextPlans = sharedData.nextPlans(at: dayOfWeek, time: time).map { $0.title }
        
        XCTAssertEqual(nextPlans, ["a", "e", "f"])
    }
    
    func testEnsureConcistencyOfStandbyPlans() throws {
        let time = Date.from(hour: 12, minute: 0, second: 0)!
        let dayOfWeek = DayOfWeek.wednesday
        
        let plans: [FocusPlan] = [
            .init(
                "a",
                start: .from(hour: 12, minute: 0)!,
                end: .from(hour: 15, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "b",
                start: .from(hour: 9, minute: 0)!,
                end: .from(hour: 11, minute: 30)!,
                daysOfWeek: [.tuesday]
            ),
            .init(
                "c",
                start: .from(hour: 7, minute: 0)!,
                end: .from(hour: 8, minute: 30)!,
                daysOfWeek: .all
            ),
            .init(
                "d",
                start: .from(hour: 11, minute: 30)!,
                end: .from(hour: 12, minute: 0)!,
                daysOfWeek: [dayOfWeek, .thursday]
            ),
            .init(
                "e",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "f",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            )
        ]
        
        sharedData.plans = plans
        sharedData.activities = Set([plans[0]].compactMap { $0.activityName.rawValue })
        
        let standByPlans = sharedData.standByPlans(at: dayOfWeek, time: time).map { $0.title }
        
        XCTAssertEqual(standByPlans, ["c", "d", "b"])
    }
    
    func testEnsureConcistencyOfAllPlans() throws {
        let time = Date.from(hour: 12, minute: 0, second: 0)!
        let dayOfWeek = DayOfWeek.wednesday
        
        let plans: [FocusPlan] = [
            .init(
                "a",
                start: .from(hour: 12, minute: 0)!,
                end: .from(hour: 15, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "b",
                start: .from(hour: 9, minute: 0)!,
                end: .from(hour: 11, minute: 30)!,
                daysOfWeek: [.tuesday]
            ),
            .init(
                "c",
                start: .from(hour: 7, minute: 0)!,
                end: .from(hour: 8, minute: 30)!,
                daysOfWeek: .all
            ),
            .init(
                "d",
                start: .from(hour: 11, minute: 30)!,
                end: .from(hour: 12, minute: 0)!,
                daysOfWeek: [dayOfWeek, .thursday]
            ),
            .init(
                "e",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "f",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "g",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [dayOfWeek],
                enabled: false
            ),
            .init(
                "h",
                start: .from(hour: 12, minute: 0)!,
                end: .from(hour: 15, minute: 30)!,
                daysOfWeek: [dayOfWeek]
            ),
            .init(
                "i",
                start: .from(hour: 13, minute: 0)!,
                end: .from(hour: 16, minute: 30)!,
                daysOfWeek: [.monday]
            )
        ]
        
        sharedData.plans = plans
        sharedData.activities = Set([plans[0], plans[7]].compactMap { $0.activityName.rawValue })
        
        let runningsPlans = sharedData.runningPlans(at: dayOfWeek).map { $0.title }
        let nextPlans = sharedData.nextPlans(at: dayOfWeek, time: time).map { $0.title }
        let standByPlans = sharedData.standByPlans(at: dayOfWeek, time: time).map { $0.title }
        let disabledPlans = sharedData.disabledPlans(at: dayOfWeek).map { $0.title }
        let allPlans = runningsPlans + nextPlans + standByPlans + disabledPlans
        
        XCTAssertEqual(runningsPlans, ["a", "h"])
        XCTAssertEqual(nextPlans, ["e", "f"])
        XCTAssertEqual(standByPlans, ["c", "d", "i", "b"])
        XCTAssertEqual(disabledPlans, ["g"])
        XCTAssertEqual(allPlans.count, plans.count)
    }

}
