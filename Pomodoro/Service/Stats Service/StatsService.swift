//
//  StatsService.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

class StatsService {
 
    let persistanceService: PersistanceService!
    
    init(persistanceService: PersistanceService) {
        self.persistanceService = persistanceService
    }
    
    convenience init() {
        self.init(persistanceService: PersistanceService())
    }
    
    /**
     Gets all the sessions from a subject and sums the time spent on that subject
     - Parameter subject: The `subject` you want to know the overall time for
     - Returns: Sum of time time spend in `subject`
     */
    func getOverallSessionTime(subject: Subject) -> Int {
        let sessions: [Session] = persistanceService.fetchSessions(subject: subject)
        return Int(sessions.reduce(0) { $0 + $1.seconds })
    }
    
    /**
     Gets the total session time for all the subjects.
     - Returns: Sum of time time spend studying
     */
    func getTotalSessionTime() -> Int {
        let sessions: [Session] = persistanceService.fetchAllSessions()
        return Int(sessions.reduce(0) { $0 + $1.seconds })
    }
    
}
