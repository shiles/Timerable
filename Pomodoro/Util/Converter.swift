//
//  Converter.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 19/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

typealias Minutes = Int

class Converter {
    
    /**
     Converts from the seconts to minutes
     - Parameter seconds: An amount of *seconds* to be converted.
     - Returns: A integer
     */
    static func secondsToMinutes(seconds: Seconds) -> Minutes {
        return seconds / 60
    }
    
    /**
     Converts from the minutes to secoudns
     - Parameter seconds: An amount of *minutes* to be converted.
     - Returns: A integer
     */
    static func minutesToSeconds(minutes: Minutes) -> Seconds {
        return minutes * 60
    }
}
