//
//  Format.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 26/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

class Format {
    
    /**
     Formats the time in seconds to the appropriate mount of time depending on its length.
     - Parameter seconds: The amount of seconds to format.
     - Returns: Formatted string to display the time with words.
    */
    static func timeToStringWords(seconds: Int) -> String {
        let time = TimeInterval(exactly: seconds)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute]
        return formatter.string(from: time!) ?? ""
    }
    
    /**
     Formats the time in seconds to the appropriate mount of time depending on its length.
     - Parameter seconds: The amount of seconds to format.
     - Returns: Formatted string to display the time without words.
     */
    static func timeToString(seconds: Int) -> String {
        let time = TimeInterval(exactly: seconds)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: time!) ?? ""
    }
    
}
