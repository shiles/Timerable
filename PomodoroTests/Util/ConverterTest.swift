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
    
    func testSecondsToMinutes(){
        let m: Int = Converter.secondsToMinutes(seconds: 60)
         XCTAssertEqual(1, m)
    }
    
    func testMinutesToSecounds(){
        let m: Int = Converter.minutesToSeconds(minutes: 25)
        XCTAssertEqual(1500, m)
    }
}
