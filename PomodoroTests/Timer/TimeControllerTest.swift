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
    
    func testBuildTimeArray(){
        let work: Int = 120
        let short: Int = 30
        let long: Int = 60
        
        let compair: [TimeChunk] = controller.buildTimeArray(work: work, short: short, long: long, sessions: 2)
        assert(compair[0].type == TimeTypes.WORK)
        assert(compair[1].type == TimeTypes.SHORT)
        assert(compair[2].type == TimeTypes.WORK)
        assert(compair[3].type == TimeTypes.LONG)
    }
}
