//
//  DailyStatTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 22/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class DailyStatTest: XCTestCase {

    func testEquitable() {
        let date = Date()
        let stat1 = DailyStat(date: date, seconds: 10)
        let stat2 = DailyStat(date: date, seconds: 10)
        
        XCTAssertTrue(stat1 == stat2)
    }
    
    func testComparable() {
        let stat1 = DailyStat(date: Date(), seconds: 15)
        let stat2 = DailyStat(date: Date(), seconds: 10)
        
        XCTAssertTrue(stat1 > stat2)
    }

}
