//
//  Converter.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 19/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

class Converter {
    
    /**
     Converts from the seconts to minutes and seconds
     - Parameter seconds: An amount of *seconds* to be converted.
     - Returns: A touple (Minute, Seconds)
     */
    static func secondsToMinutesAndSecounds(seconds: Int) -> (Int, Int) {
       return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    /**
     Converts from the seconts to minutes
     - Parameter seconds: An amount of *seconds* to be converted.
     - Returns: A integer
     */
    static func secondsToMinutes(seconds: Int) -> (Int) {
        return seconds / 60
    }
    
    /**
     Converts from the minutes to secoudns
     - Parameter seconds: An amount of *minutes* to be converted.
     - Returns: A integer
     */
    static func minutesToSeconds(minutes: Int) -> (Int) {
        return minutes * 60
    }

}
