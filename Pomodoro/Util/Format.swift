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
    static func timeToStringWords(seconds: Seconds) -> String {
        let time = TimeInterval(exactly: seconds)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = seconds < 60 ? [.second] : [.day, .hour, .minute]
        return formatter.string(from: time!) ?? ""
    }
    
    /**
     Formats the time in seconds to the appropriate mount of time depending on its length in a
     way that will be easy to understand for voice over use.
     - Parameter seconds: The amount of seconds to format.
     - Returns: Formatted string to display the time with words.
     */
    static func timeToAccessibiltyWords(seconds: Seconds) -> String {
        let time = TimeInterval(exactly: seconds)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: time!) ?? ""
    }
    
    /**
     Formats the time in seconds to the appropriate mount of time depending on its length.
     - Parameter seconds: The amount of seconds to format.
     - Returns: Formatted string to display the time without words.
     */
    static func timeToString(seconds: Seconds) -> String {
        let time = TimeInterval(exactly: seconds)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: time!) ?? ""
    }
    
    /**
     Formats a date into the corresponding weekday in a three letter format, uppercased.
     - Parameter date: The date to be formatted
     - Returns: The weekday as a string, like `MON`.
     */
    static func dateToShortWeekDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date).uppercased()
    }
    
    /**
     Formats a date into the corresponding weekday in a full format.
     - Parameter date: The date to be formatted
     - Returns: The weekday as a string, like `MON`.
     */
    static func dateToWeekDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    /**
     Formats a date into a short description that includes Month and Date
     - Parameter date: The date to be formatted
     - Returns: The weekday as a string, like `Wednesday, 8th May`.
     */
    static func dateToShortDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    /**
     Formats a date into a time
     - Parameter date: The date to be formatted
     - Returns: The weekday as a string, like `8`.
     */
    static func dateToTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
}
