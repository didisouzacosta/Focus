//
//  FocusTests.swift
//  FocusTests
//
//  Created by Adriano Souza Costa on 04/07/24.
//

import XCTest
@testable import Focus

final class FocusTests: XCTestCase {

    func testEnsureSum() throws {
        let firstDeviceActivity = AppDeviceActivity(
            "com.test",
            token: nil,
            name: "test",
            duration: 15.minute,
            notifications: 2,
            pickups: 0
        )
        
        let secondDeviceActivity = AppDeviceActivity(
            "com.test.2",
            token: nil,
            name: "test 2",
            duration: 10.minute,
            notifications: 3,
            pickups: 1
        )
        
        let sum = firstDeviceActivity + secondDeviceActivity
        
        XCTAssertEqual(sum.bundle, "com.test")
        XCTAssertEqual(sum.duration, 25.minute)
        XCTAssertEqual(sum.notifications, 5)
        XCTAssertEqual(sum.pickups, 1)
    }

}
