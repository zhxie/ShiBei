//
//  ShiBeiTests.swift
//  ShiBeiTests
//
//  Created by Xie Zhihao on 2022/6/5.
//

import XCTest
@testable import ShiBei

class DateTests: XCTestCase {

    func testDayToNow() throws {
        let hundreds = Date.now.advanced(by: -86400 * 99)
        let yesterday = Date.now.advanced(by: -86400)
        let today = Date.now
        let tomorrow = Date.now.advanced(by: 86400)
        
        XCTAssertEqual(hundreds.dayToNow, 99)
        XCTAssertEqual(yesterday.dayToNow, 1)
        XCTAssertEqual(today.dayToNow, 0)
        XCTAssertEqual(tomorrow.dayToNow, -1)
    }

}
