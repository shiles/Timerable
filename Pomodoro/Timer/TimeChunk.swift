//
//  TimeChunk.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 16/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

struct TimeChunk: Equatable {
    var type: TimeTypes!
    var timeLength: Int!
    var timeRemaining: Int!
    
    init(type: TimeTypes, initialTime: Int){
        self.type = type
        self.timeLength = initialTime
        self.timeRemaining = initialTime
    }
}
