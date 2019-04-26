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
    
    func testLastWeeksSessionTimes() {
        let results: [DailyStat] = statsService.getLastWeeksSessionTimes()
        let expected: [DailyStat] = buildLastWeeksValues()
        
        XCTAssertEqual(expected.first?.seconds, results.first?.seconds)
    }
    
    private func buildLastWeeksValues() -> [DailyStat] {
        let now = Date()
        var lastWeek: [DailyStat] = [DailyStat(date: now, seconds: 120)]
        for daysBack in 1...6 {
            lastWeek.append(DailyStat(date: Calendar.current.date(byAdding: .day, value: -daysBack, to: now)!, seconds: 0))
        }
        
        return lastWeek
    }
}

class MockStatsPersistanceService: PersistanceService {
    
    override func fetchSessions(subject: Subject) -> [Session] {
        let session = Session(context: context)
        session.seconds = Int64(exactly: 60.0)!
        session.date = Date()
        session.subject = subject
        return [session, session]
    }
    
    override func fetchAllSessions() -> [Session] {
        let session = Session(context: context)
        session.seconds = Int64(exactly: 60.0)!
        session.date = Date()
        return [session, session]
    }
    
    override func fetchSessionsDateRange(start: Date, end: Date) -> [Session] {
        let session = Session(context: context)
        session.seconds = Int64(exactly: 60.0)!
        session.date = Date()
        return [session, session]
    }
}
