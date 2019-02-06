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

    func secondsToMinutesAndSecondsTest() {
        let (m, s): (Int, Int) = Converter.secondsToMinutesAndSecounds(seconds: 90)
        XCTAssertEqual(1, m)
        XCTAssertEqual(30, s)
    }
    
    func secondsToMinutesTest(){
        let m: Int = Converter.secondsToMinutes(seconds: 60)
         XCTAssertEqual(1, m)
    }
    
    func minutesToSecoundsTest(){
        let m: Int = Converter.secondsToMinutes(seconds: 25)
        XCTAssertEqual(1500, m)
    }
}
