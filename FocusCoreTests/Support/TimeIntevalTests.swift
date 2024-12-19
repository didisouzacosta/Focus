//
//  TimeIntervalTests.swift
//  FocusCoreTests
//
//  Created by Adriano Souza Costa on 11/07/24.
//

import XCTest

@testable import FocusCore

final class TimeIntervalTests: XCTestCase {
    
    func testEnsureHourFormatter() {
        let time = Double(300.000)
        XCTAssertEqual(time.timeFormatter(maximumUnitCount: 1), "5m")
    }
    
}
