//
//  StatsServiceTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 18/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class StatsServiceTest: XCTestCase {

    var statsService: StatsService!
    let persistanceService = MockStatsPersistanceService()
    
    override func setUp() {
        self.statsService = StatsService(persistanceService: persistanceService)
    }

    func testOverallSessionTime() {
        let value = statsService.getOverallSessionTime(subject: Subject(context: persistanceService.context))
        XCTAssertEqual(120, value)
    }
    
    func testTotalSessionTime() {
        let value = statsService.getTotalSessionTime()
        XCTAssertEqual(120, value)
    }

}

class MockStatsPersistanceService: PersistanceService {
    
    override func fetchSessions(subject: Subject) -> [Session] {
        let session = Session(context: context)
        session.seconds = Int64(exactly: 60.0)!
        session.date = NSDate()
        session.subject = subject
        return [session, session]
    }
    
    override func fetchAllSessions() -> [Session] {
        let session = Session(context: context)
        session.seconds = Int64(exactly: 60.0)!
        session.date = NSDate()
        return [session, session]
    }
}
