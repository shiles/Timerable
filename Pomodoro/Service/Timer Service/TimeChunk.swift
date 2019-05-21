//
//  TimeChunk.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 16/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

typealias Seconds = Int

struct TimeChunk: Equatable {
    var type: TimeTypes!
    var timeLength: Seconds!
    var timeRemaining: Seconds!
    
    init(type: TimeTypes, initialTime: Seconds) {
        self.type = type
        self.timeLength = initialTime
        self.timeRemaining = initialTime
    }
}
