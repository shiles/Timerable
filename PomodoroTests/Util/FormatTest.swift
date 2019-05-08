//
//  FormatTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 26/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
@testable import Pomodoro

class FormatTest: XCTestCase {

    func testWithLengthInHoursAndMinutesWords() {
        let expected = "1 hour, 1 minute"
        XCTAssertEqual(expected, Format.timeToStringWords(seconds: 3660))
    }
    
    func testWithLengthInDaysAndHoursWords() {
        let expected = "7 days, 55 minutes"
        XCTAssertEqual(expected, Format.timeToStringWords(seconds: 608100))
    }
    
    func testWithLengthInMinutes() {
        let expected = "2:05"
        XCTAssertEqual(expected, Format.timeToString(seconds: 125))
    }
    
    func testWithLengthInSeconds() {
        let expected = "59"
        XCTAssertEqual(expected, Format.timeToString(seconds: 59))
    }
    
    func testDateToShortWeekDay() {
        let expected = "WED"
        var components = DateComponents()
        components.day = 20
        components.month = 3
        components.year = 2019
        XCTAssertEqual(expected, Format.dateToShortWeekDay(date: Calendar.current.date(from: components)!))
    }
    
    func testDateToWeekDay() {
        let expected = "Wednesday"
        var components = DateComponents()
        components.day = 20
        components.month = 3
        components.year = 2019
        XCTAssertEqual(expected, Format.dateToWeekDay(date: Calendar.current.date(from: components)!))
    }
    
    func testDateToShortDescription() {
        let expected = "Wednesday, May 8"
        var components = DateComponents()
        components.day = 8
        components.month = 5
        components.year = 2019
        XCTAssertEqual(expected, Format.dateToShortDate(date: Calendar.current.date(from: components)!))
    }
}
