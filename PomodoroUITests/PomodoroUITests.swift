//
//  PomodoroUITests.swift
//  PomodoroUITests
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest

class PomodoroUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSkipButtonEnablesWhenStartingTimer() {
        //Start Timer
        let app = XCUIApplication()
        app.buttons["START"].tap()
        app.sheets["Select Subject for Session"].buttons["English"].tap()
        //Verify skip Button is enabled
        XCTAssertTrue(app.buttons["Skip"].isEnabled)
    }
    
    func testSkipButtonDisablesWhenResetingTimer(){
        //Reset Timer
        let app = XCUIApplication()
        app.buttons["START"].tap()
        app.sheets["Select Subject for Session"].buttons["English"].tap()
        app.buttons["RESET"].tap()
        
        //Verify skip Button is disabled
        XCTAssertFalse(app.buttons["Skip"].isEnabled)
    }
    
    func testResetButtonShowsWhenStartingTimer() {
        //Start Timer
        let app = XCUIApplication()
        app.buttons["START"].tap()
        app.sheets["Select Subject for Session"].buttons["English"].tap()
        //Verify Reset button isn't hidden
        XCTAssertTrue(app.buttons["RESET"].isEnabled)
    }
}
