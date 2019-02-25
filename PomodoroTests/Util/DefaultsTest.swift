//
//  DefaultsTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 25/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class DefaultsTest: XCTestCase {

    let defaults = UserDefaults.standard
    
    override func setUp() {
        defaults.registerDefaults()
        defaults.setSubject("English")
    }

    override func tearDown() {
        defaults.setWorkTime(1500)
        defaults.setShortTime(300)
        defaults.setLongTime(1800)
        defaults.setSessionLength(4)
    }

    func testGetWorkTime() {
        XCTAssertEqual(1500, defaults.getWorkTime(), "Registered defualt work time incorrect")
    }
    
    func testGetShortTime() {
        XCTAssertEqual(300, defaults.getShortTime(), "Registered defualt short time incorrect")
    }
    
    func testGetLongTime() {
        XCTAssertEqual(1800, defaults.getLongTime(), "Registered defualt long time incorrect")
    }
    
    func testGetSessionLength() {
        XCTAssertEqual(4, defaults.getSessionLength(), "Registered defualt long time incorrect")
    }
    
    func testGetSubject(){
        XCTAssertEqual("English", defaults.getSubjectName(), "Subject name not correct")
    }
    
    func testSetWorkTime() {
        let workTime = 10
        defaults.setWorkTime(workTime)
        XCTAssertEqual(workTime, defaults.getWorkTime(), "Registered defualt work time incorrect")
    }
    
    func testSetShortTime() {
        let shortTime = 10
        defaults.setShortTime(shortTime)
        XCTAssertEqual(shortTime, defaults.getShortTime(), "Registered defualt short time incorrect")
    }
    
    func testSetLongTime() {
        let longTime = 10
        defaults.setLongTime(longTime)
        XCTAssertEqual(longTime, defaults.getLongTime(), "Registered defualt long time incorrect")
    }
    
    func testSetSessionLength() {
        let sessionLength = 2
        defaults.setSessionLength(sessionLength)
        XCTAssertEqual(sessionLength, defaults.getSessionLength(), "Registered defualt long time incorrect")
    }
    
    func testSetSubject(){
        let subject = "Spanish"
        defaults.setSubject(subject)
        XCTAssertEqual(subject, defaults.getSubjectName(), "Subject name not correct")
    }
}
