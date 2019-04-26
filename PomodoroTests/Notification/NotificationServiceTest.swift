//
//  NotificationServieTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 11/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
import UserNotifications
@testable import Pomodoro

class NotificationServiceTest: XCTestCase {

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
        let work = TimeChunk(type: TimeTypes.work, initialTime: 1500)
        let shortBreak = TimeChunk(type: TimeTypes.short, initialTime: 180)
        let longBreak = TimeChunk(type: TimeTypes.long, initialTime: 1800)
        
        return [work, shortBreak, work, longBreak]
    }
}
