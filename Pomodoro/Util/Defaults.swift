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
        case Work
        case Long
        case Short
        case AutoReset
        case SessionLength
    }
    
    /**
     Sets up the default values to be used when no defined values
     been given by a user within the settings.
     */
    func registerDefaults() -> Void{
      register(defaults: [DefaultKeys.Work.rawValue : 1500,
                          DefaultKeys.Short.rawValue : 300,
                          DefaultKeys.Long.rawValue : 1800,
                          DefaultKeys.AutoReset.rawValue: true,
                          DefaultKeys.SessionLength.rawValue : 4])
    }
    
    /**
     Sets the work time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setWorkTime(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.Work.rawValue)
    }
    
    /**
    Gets the work time value in seconds.
     - Returns: The `work time` in seconds
     */
    func getWorkTime() -> Int {
        return integer(forKey: DefaultKeys.Work.rawValue)
    }
    
    /**
     Sets the long break time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setLongTime(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.Long.rawValue)
    }
    
    /**
     Gets the long break value in seconds.
     - Returns: The `work time` in seconds
     */
    func getLongTime() -> Int {
        return integer(forKey: DefaultKeys.Long.rawValue)
    }
    
    /**
     Sets the short break time value in seconds.
     - Parameter value: The number of seconds to set.
     */
    func setShortTime(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.Short.rawValue)
    }
    
    /**
     Gets the short break value in seconds.
     - Returns: The `work time` in seconds
     */
    func getShortTime() -> Int {
        return integer(forKey: DefaultKeys.Short.rawValue)
    }
    
    /**
     Sets the autoreset boolean value
     - Parameter value: The boolean of if you want to autoreset or not.
     */
    func setAutoReset(_ value: Bool) -> Void {
        set(value, forKey: DefaultKeys.AutoReset.rawValue)
    }
    
    /**
     Gets the autoreset boolean value
     - Returns: The `autoreset` boolean flag
     */
    func getAutoReset() -> Bool {
        return bool(forKey: DefaultKeys.AutoReset.rawValue)
    }
    
    /**
     Sets the session length in number of work chunks.
     - Parameter value: The number of sessions.
     */
    func setSessionLength(_ value: Int) -> Void {
        set(value, forKey: DefaultKeys.SessionLength.rawValue)
    }
    
    /**
     Gets the session length in the number of work chunks
     - Returns: The number of `sessions`.
     */
    func getSessionLength() -> Int {
        return integer(forKey: DefaultKeys.SessionLength.rawValue)
    }
}
