//
//  TimerTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 25/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class TimerServiceTest: XCTestCase {

    var timeController: TimerService!
    let defaults = MockTimerDefualts()
    
    override func setUp() {
        timeController = TimerService(persistanceService: MockTimerPersistanceService(), notificationService: NotificationService(), defaults: MockTimerDefualts())
        timeController.timeTickerDelegate = MockTimeTickerDeligate()
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
        
        let session = self.buildDefualtSession()
        timeController.recalculateTimeChunks()
        
        XCTAssertEqual(timeController.session, session, "Recalculated worktime doesn't match")
    }

    private func buildDefualtSession() -> [TimeChunk] {
        let work = TimeChunk(type: TimeTypes.work, initialTime: defaults.getWorkTime())
        let shortBreak = TimeChunk(type: TimeTypes.short, initialTime: defaults.getShortTime())
        let longBreak = TimeChunk(type: TimeTypes.long, initialTime: defaults.getLongTime())
        
        return [work, shortBreak, work, longBreak]
    }
}

class MockTimeTickerDeligate: TimeTickerDelegate {
    func timerDecrement(timeChunk: TimeChunk) {}
    
    func resetTimerDisplay(timeChunk: TimeChunk) {}
    
    func isFinished() {}
    
    func chunkCompleted() {}
}

class MockTimerPersistanceService: PersistanceService {
    override func fetchSubject(name: String) -> Subject? {
        let subject = Subject(context: context)
        subject.name = "English"
        return subject
    }
    
    override func saveSession(seconds: Int, subject: Subject) -> Session? {
        return Session()
    }
}

class MockTimerDefualts: Defaults {
    override func getWorkTime() -> Int {
        return 1500
    }
    
    override func getShortTime() -> Int {
        return 360
    }
    
    override func getLongTime() -> Int {
        return 1800
    }
    
    override func getNumberOfSessions() -> Int {
        return 2
    }
}


