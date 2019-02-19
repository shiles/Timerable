//
//  Defaults.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 03/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum DefaultKeys: String {
        case work
        case long
        case short
        case autoReset
        case sessionLength
        case subject
    }
    
    /**
     Sets up the default values to be used when no defined values
     been given by a user within the settings.
     */
    func registerDefaults() -> Void{
      register(defaults: [DefaultKeys.work.rawValue : 1500,
                          DefaultKeys.short.rawValue : 300,
                          DefaultKeys.long.rawValue : 1800,
                          DefaultKeys.autoReset.rawValue: true,
                          DefaultKeys.sessionLength.rawValue : 4])
    }
    
    /**
     Sets the work time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setWorkTime(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.work.rawValue)
    }
    
    /**
    Gets the work time value in seconds.
     - Returns: The `work time` in seconds
     */
    func getWorkTime() -> Int {
        return integer(forKey: DefaultKeys.work.rawValue)
    }
    
    /**
     Sets the long break time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setLongTime(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.long.rawValue)
    }
    
    /**
     Gets the long break value in seconds.
     - Returns: The `work time` in seconds
     */
    func getLongTime() -> Int {
        return integer(forKey: DefaultKeys.long.rawValue)
    }
    
    /**
     Sets the short break time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setShortTime(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.short.rawValue)
    }
    
    /**
     Gets the short break value in seconds.
     - Returns: The `work time` in seconds
     */
    func getShortTime() -> Int {
        return integer(forKey: DefaultKeys.short.rawValue)
    }
    
    /**
     Sets the autoreset boolean value
     - Parameter value: The boolean of if you want to autoreset or not.
     */
    func setAutoReset(_ value: Bool) -> Void {
        set(value, forKey: DefaultKeys.autoReset.rawValue)
    }
    
    /**
     Gets the autoreset boolean value
     - Returns: The `autoreset` boolean flag
     */
    func getAutoReset() -> Bool {
        return bool(forKey: DefaultKeys.autoReset.rawValue)
    }
    
    /**
     Sets the session length in number of work chunks.
     - Parameter value: The number of sessions.
     */
    func setSessionLength(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.sessionLength.rawValue)
    }
    
    /**
     Gets the session length in the number of work chunks
     - Returns: The number of `sessions`.
     */
    func getSessionLength() -> Int {
        return integer(forKey: DefaultKeys.sessionLength.rawValue)
    }
    
    /**
     Sets the subject for the session
     - Parameter value: the subject
     */
    func setSubject(_ value: String) -> Void {
        set(value, forKey: DefaultKeys.subject.rawValue)
    }
    
    /**
     Gets the subect for the session.
     - Returns: The subject for the session
     */
    func getSubject() -> String {
        return string(forKey: DefaultKeys.subject.rawValue)!
    }
}
