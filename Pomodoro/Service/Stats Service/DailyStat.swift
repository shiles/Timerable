//
//  DailyStat.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 22/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

class DailyStat: Equatable, Comparable {
    
    let date: Date!
    let seconds: Seconds!
    
    init(date: Date, seconds: Seconds) {
        self.date = date
        self.seconds = seconds
    }

    static func == (lhs: DailyStat, rhs: DailyStat) -> Bool {
        return lhs.date == rhs.date && lhs.seconds == rhs.seconds
    }
    
    static func < (lhs: DailyStat, rhs: DailyStat) -> Bool {
        return lhs.seconds < rhs.seconds
    }
}
