//
//  TimeControllerTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 15/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class TimeControllerTest: XCTestCase {

    var controller: TimeController!
    
    override func setUp() {
        controller = TimeController()
        continueAfterFailure = false
    }

    override func tearDown() {
        controller = nil
    }

    func testIsDoneWithZeroSeconds(){
        controller.timeRemaining = 0
        XCTAssertTrue(controller.isDone())
    }
    
    func testIsDoneWithNonZeroSeconds(){
        controller.timeRemaining = 1
        XCTAssertFalse(controller.isDone())
    }
    
    func testSecondsToMinutesAndSeconds() {
        let time: Int = 90
        let (m, s) = controller.secondsToMinutesAndSecounds(seconds: time)
        XCTAssertEqual(m, 1)
        XCTAssertEqual(s, 30)
    }
}
