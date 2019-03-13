//
//  NotificationControllerTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 11/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
import UserNotifications
@testable import Pomodoro

class NotificationControllerTest: XCTestCase {

    let notificationController = NotificationService()
    
    func testScheduleNotifications() {
        notificationController.scheduleNotifications(timeChunks: buildDefualtSession())
        XCTAssertTrue((UIApplication.shared.scheduledLocalNotifications?.count)! > 0)
    }
    
    func testRescheduleNotifications() {
        notificationController.rescheduleNotifications(timeChunks: buildDefualtSession())
        XCTAssertTrue((UIApplication.shared.scheduledLocalNotifications?.count)! > 0)
    }
    
    func testRemoveNotifications() {
        notificationController.removeNotifications()
        XCTAssertTrue((UIApplication.shared.scheduledLocalNotifications?.count)! == 0)
    }
    
    private func buildDefualtSession() -> [TimeChunk] {
        let work: Int = 1500
        let short: Int = 300
        let long: Int = 1800
        let workTime = TimeChunk(type: TimeTypes.work, timeLength: work, timeRemaining: work)
        let workBreakShort = TimeChunk(type: TimeTypes.short, timeLength: short, timeRemaining: short)
        let workBreakLong = TimeChunk(type: TimeTypes.long, timeLength: long, timeRemaining: long)
        
        return [workTime, workBreakShort, workTime, workBreakLong]
    }
}

