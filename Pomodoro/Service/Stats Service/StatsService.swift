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
    func getOverallSessionTime(subject: Subject) -> Seconds {
        let sessions: [Session] = persistanceService.fetchSessions(subject: subject)
        return Seconds(sessions.reduce(0) { $0 + $1.seconds })
    }
    
    /**
     Gets the total session time for all the subjects.
     - Returns: Sum of time time spend studying
     */
    func getTotalSessionTime() -> Seconds {
        let sessions: [Session] = persistanceService.fetchAllSessions()
        return Seconds(sessions.reduce(0) { $0 + $1.seconds })
    }
    
    /**
     Gets the session time for each day in the last week from a date
     - Returns: Sum of time time spend studying
     */
    func getLastWeeksSessionTimes() -> [DailyStat] {
        let lastWeek = self.getDatesForLastWeek()
   
        var summedData: [DailyStat] = Array()
        for date in lastWeek {
            let startDate = Calendar.current.startOfDay(for: date)
            let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            let sessions = persistanceService.fetchSessionsDateRange(start: startDate, end: endDate)
            
            summedData.append(DailyStat(date: endDate, seconds: Int(sessions.reduce(0) { $0 + $1.seconds })))
        }

        return summedData.reversed()
    }
    
    /**
     Gets a list of the last weeks dates.
     - Returns: A list of dates for today and the last 6 days.
     */
    private func getDatesForLastWeek() -> [Date] {
        let now = Date()
        var lastWeek: [Date] = [now]
        
        for days in 1...6 {
            lastWeek.append(Calendar.current.date(byAdding: .day, value: -days, to: now)!)
        }
        
        return lastWeek
    }
}
