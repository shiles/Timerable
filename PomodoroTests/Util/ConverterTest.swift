//
//  ConverterTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 21/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class ConverterTest: XCTestCase {

    func testSecondsToMinutesAndSeconds() {
        let (m, s): (Int, Int) = Converter.secondsToMinutesAndSecounds(seconds: 90)
        XCTAssertEqual(1, m)
        XCTAssertEqual(30, s)
    }
    
    func testSecondsToMinutes(){
        let m: Int = Converter.secondsToMinutes(seconds: 60)
         XCTAssertEqual(1, m)
    }
    
    func testMinutesToSecounds(){
        let m: Int = Converter.secondsToMinutes(seconds: 25)
        XCTAssertEqual(1500, m)
    }
    
    func testSecondsToHoursMinutesSeconds(){
        let (h, m, s) = Converter.secondsToHoursMinutesSeconds(seconds: 3600)
        XCTAssertEqual(1, h)
        XCTAssertEqual(0, m)
        XCTAssertEqual(0, s)
    }
}
