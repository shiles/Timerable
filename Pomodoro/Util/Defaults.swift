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
    
    func registerDefaults() -> Void{
      register(defaults: [DefaultKeys.Work.rawValue : 1500,
                          DefaultKeys.Short.rawValue : 300,
                          DefaultKeys.Long.rawValue : 1800,
                          DefaultKeys.AutoReset.rawValue: true,
                          DefaultKeys.SessionLength.rawValue : 4])
    }
    
    func setWorkTime(value: Int) -> Void {
        set(value, forKey: DefaultKeys.Work.rawValue)
    }
    
    func getWorkTime() -> Int {
        return integer(forKey: DefaultKeys.Work.rawValue)
    }
    
    func setLongTime(value: Int) -> Void {
        set(value, forKey: DefaultKeys.Long.rawValue)
    }
    
    func getLongTime() -> Int {
        return integer(forKey: DefaultKeys.Long.rawValue)
    }
    
    func setShortTime(value: Int) -> Void {
        set(value, forKey: DefaultKeys.Short.rawValue)
    }
    
    func getShortTime() -> Int {
        return integer(forKey: DefaultKeys.Short.rawValue)
    }
    
    func setAutoReset(value: Bool) -> Void {
        set(value, forKey: DefaultKeys.AutoReset.rawValue)
    }
    
    func getAutoReset() -> Bool {
        return bool(forKey: DefaultKeys.AutoReset.rawValue)
    }
    
    func setSessionLength(value: Int) -> Void {
        set(value, forKey: DefaultKeys.SessionLength.rawValue)
    }
    
    func getSessionLength() -> Int {
        return integer(forKey: DefaultKeys.SessionLength.rawValue)
    }
    
}
