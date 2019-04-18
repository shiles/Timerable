//
//  Defaults.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 03/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

enum SessionState: Double {
    case ready
    case paused
    case timing
}

class Defaults: UserDefaults {
    
    enum DefaultKeys: String {
        case work
        case long
        case short
        case sessionLength
        case dailyGoal
        case subject
        case backgroundedTime
        case sessionStatus
    }
    
    let defaults = UserDefaults.standard
    
    /**
     Sets up the default values to be used when no defined values
     been given by a user within the settings.
     */
    func registerDefaults() -> Void {
      defaults.register(defaults: [DefaultKeys.work.rawValue : 1500,
                          DefaultKeys.short.rawValue : 300,
                          DefaultKeys.long.rawValue : 1800,
                          DefaultKeys.sessionLength.rawValue : 4,
                          DefaultKeys.dailyGoal.rawValue : 12,
                          DefaultKeys.sessionStatus.rawValue : SessionState.ready.rawValue])
    }
    
    /**
     Reset the values to the defualts
     */
    func resetToDefaults() -> Void {
        setWorkTime(1500)
        setShortTime(300)
        setLongTime(1800)
        setNumberOfSessions(4)
        setDailyGoal(12)
    }
    
    /**
     Sets the work time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setWorkTime(_ value: Int) -> Void {
        defaults.set(value, forKey: DefaultKeys.work.rawValue)
    }
    
    /**
    Gets the work time value in seconds.
     - Returns: The `work time` in seconds
     */
    func getWorkTime() -> Int {
        return defaults.integer(forKey: DefaultKeys.work.rawValue)
    }
    
    /**
     Sets the long break time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setLongTime(_ value: Int) -> Void {
        defaults.set(value, forKey: DefaultKeys.long.rawValue)
    }
    
    /**
     Gets the long break value in seconds.
     - Returns: The `work time` in seconds
     */
    func getLongTime() -> Int {
        return defaults.integer(forKey: DefaultKeys.long.rawValue)
    }
    
    /**
     Sets the short break time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setShortTime(_ value: Int) -> Void {
        defaults.set(value, forKey: DefaultKeys.short.rawValue)
    }
    
    /**
     Gets the short break value in seconds.
     - Returns: The `work time` in seconds
     */
    func getShortTime() -> Int {
        return defaults.integer(forKey: DefaultKeys.short.rawValue)
    }
    
    /**
     Sets the session length in number of work chunks.
     - Parameter value: The number of sessions.
     */
    func setNumberOfSessions(_ value: Int) -> Void {
        defaults.set(value, forKey: DefaultKeys.sessionLength.rawValue)
    }
    
    /**
     Gets the session length in the number of work chunks
     - Returns: The number of `sessions`.
     */
    func getNumberOfSessions() -> Int {
        return defaults.integer(forKey: DefaultKeys.sessionLength.rawValue)
    }
    
    /**
     Sets the amount of sessions for a daily goal
     - Parameter value: The number of sessions.
     */
    func setDailyGoal(_ value: Int) -> Void {
        defaults.set(value, forKey: DefaultKeys.dailyGoal.rawValue)
    }
    
    /**
     Gets the number of goals for daily goals
     - Returns: The daily goal amount of work sessions.
     */
    func getDailyGoal() -> Int {
        return defaults.integer(forKey: DefaultKeys.dailyGoal.rawValue)
    }
    
    /**
     Sets the subject name for the session
     - Parameter value: The subject
     */
    func setSubject(_ value: String) -> Void {
        defaults.set(value, forKey: DefaultKeys.subject.rawValue)
    }
    
    /**
     Gets the subects name for the session.
     - Returns: The subject for the session
     */
    func getSubjectName() -> String {
        return defaults.string(forKey: DefaultKeys.subject.rawValue)!
    }
    
    /**
     Sets the time the app was backgrounded.
     - Parameter backgroundedTime: The date the app was backgrounded
     */
    func setBackgroundedTime(_ backgroundedTime: Date) {
        defaults.set(backgroundedTime, forKey: DefaultKeys.backgroundedTime.rawValue)
    }
    
    /**
     Gets the time the app was backgrounded.
     - Returns: The date that the app was backgrounded
     */
    func getBackgroundedTime() -> Date? {
        return defaults.object(forKey: DefaultKeys.backgroundedTime.rawValue) as? Date
    }
    
    /**
     Remove the backgrounded time.
     */
    func removeBackgroundedTime() -> Void {
        defaults.removeObject(forKey: DefaultKeys.backgroundedTime.rawValue)
    }
    
    /**
     Sets the timer state
     - Parameter value: The SessionState
     */
    func setTimerStatus(_ value: SessionState) -> Void {
        defaults.set(value.rawValue, forKey: DefaultKeys.sessionStatus.rawValue)
    }
    
    /**
     Gets the state of the timer
     - Returns: The state of the timer
     */
    func getTimerStatus() -> SessionState {
        return SessionState(rawValue: defaults.double(forKey: DefaultKeys.sessionStatus.rawValue))!
    }
}
