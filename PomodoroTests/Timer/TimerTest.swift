//
//  TimerTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 25/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class TimerTest: XCTestCase {

    var timeController: TimeController!
    var defaults = UserDefaults.standard
    
    override func setUp() {
        defaults.setSessionLength(2)
        timeController = TimeController()
        timeController.timeTickerDelegate = MockTimeTickerDeligate()
    }

    override func tearDown() {
        defaults.setSessionLength(4)
        defaults.setWorkTime(1500)
        defaults.setShortTime(300)
        defaults.setLongTime(1800)
    }

    func testBuildTimeArray() {
        let session = self.buildDefualtSession()
        let generatedSession: [TimeChunk] = timeController.session!
        
        XCTAssertEqual(session, generatedSession, "Generated session doesn't match the user defaults")
    }
    
    func testStartTimer() {
        timeController.startTimer()
        
        XCTAssert(timeController.timer.isValid, "Timer didn't start")
    }
    
    func testStopTimer() {
        timeController.stopTimer()
        
        XCTAssert(!timeController.timer.isValid, "Timer didn't stop")
    }
    
    func testSkipChunk() {
        var sessionDroppedHead = timeController.session
        _ = sessionDroppedHead!.removeFirst()
        timeController.skipChunk()
        
        XCTAssertEqual(timeController.session, sessionDroppedHead, "Skipped chunk isn't the session without head of list")
    }
    
    func testResetSession() {
        let session = self.buildDefualtSession()
        timeController.resetSession()

        XCTAssert(!timeController.timer.isValid, "Timer didn't stop")
        XCTAssertEqual(session, timeController.session, "Session wasn't regenerated after session ended")
    }
    
    func testIsChunkDone() {
        timeController.session![0].timeRemaining = 1
        timeController.decrementTimer()
        
        var sessionDroppedHead = self.buildDefualtSession()
        _ = sessionDroppedHead .removeFirst()
        
        XCTAssertEqual(sessionDroppedHead, timeController.session, "Session wasn't dropped after chunk is done")
    }
    
    func testRecalculateTimeChunk() {
        timeController.resetSession()
        defaults.setWorkTime(10)
        defaults.setShortTime(10)
        defaults.setLongTime(10)
        
        let session = self.buildDefualtSession()
        timeController.recalculateTimeChunks()
        
        XCTAssertEqual(timeController.session, session, "Recalculated worktime doesn't match")
    }
    
    private func buildDefualtSession() -> [TimeChunk] {
        let work: Int = defaults.getWorkTime()
        let short: Int = defaults.getShortTime()
        let long: Int = defaults.getLongTime()
        let workTime = TimeChunk(type: TimeTypes.work, timeLength: work, timeRemaining: work)
        let workBreakShort = TimeChunk(type: TimeTypes.short, timeLength: short, timeRemaining: short)
        let workBreakLong = TimeChunk(type: TimeTypes.long, timeLength: long, timeRemaining: long)
        
        return [workTime, workBreakShort, workTime, workBreakLong]
    }
}

class MockTimeTickerDeligate: TimeTickerDelegate {
    func timerDecrement(timeChunk: TimeChunk) {
        //Intentially left empty for mocking
    }
    
    func resetTimerDisplay(timeChunk: TimeChunk) {
        //Intentially left empty for mocking
    }
    
    func isFinished() {
        //Intentially left empty for mocking
    }
}
