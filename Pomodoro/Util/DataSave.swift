//
//  DataSave.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 31/05/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

class DataSave {
    let persistanceService = PersistanceService()
    
    func saveMockData() {
        deleteCurrentData()
        deleteCurrentSubjects()
        buildSubjects()
        saveData()
    }
    
    private func buildSubjects() {
        _ = persistanceService.saveSubject(name: MockSubjects.compSci.name())
        _ = persistanceService.saveSubject(name: MockSubjects.dev.name())
        _ = persistanceService.saveSubject(name: MockSubjects.english.name())
        _ = persistanceService.saveSubject(name: MockSubjects.spanish.name())
        _ = persistanceService.saveSubject(name: MockSubjects.math.name())
        _ = persistanceService.saveSubject(name: MockSubjects.physics.name())
        _ = persistanceService.saveSubject(name: MockSubjects.bam.name())
    }
    
    private func deleteCurrentData() {
        persistanceService.removeAllSessions()
    }
    
    private func deleteCurrentSubjects() {
        persistanceService.fetchAllSubjects().forEach { persistanceService.remove(objectID: $0.objectID) }
    }
    
    private func saveData() {
        saveSession(subject: .compSci, daysAgo: 7, startHour: 8)
        
        saveSession(subject: .compSci, daysAgo: 6, startHour: 8)
        saveSession(subject: .dev, daysAgo: 6, startHour: 11)
        saveSession(subject: .english, daysAgo: 6, startHour: 15)
        saveSession(subject: .math, daysAgo: 6, startHour: 17)
        
        saveSession(subject: .dev, daysAgo: 5, startHour: 11)
        saveSession(subject: .bam, daysAgo: 5, startHour: 15)
        saveSession(subject: .spanish, daysAgo: 5, startHour: 17)
        
        saveSession(subject: .physics, daysAgo: 4, startHour: 8)
        saveSession(subject: .compSci, daysAgo: 4, startHour: 11)
        
        saveSession(subject: .math, daysAgo: 3, startHour: 8)
        saveSession(subject: .compSci, daysAgo: 3, startHour: 11)
        saveSession(subject: .physics, daysAgo: 3, startHour: 15)
        saveSession(subject: .dev, daysAgo: 3, startHour: 17)
        saveSession(subject: .compSci, daysAgo: 3, startHour: 22)
        
        saveSession(subject: .compSci, daysAgo: 2, startHour: 9)
        saveSession(subject: .bam, daysAgo: 2, startHour: 12)
        saveSession(subject: .math, daysAgo: 2, startHour: 16)
        saveSession(subject: .dev, daysAgo: 2, startHour: 20)
        
        saveSession(subject: .bam, daysAgo: 1, startHour: 7)
        saveSession(subject: .english, daysAgo: 1, startHour: 10)
        saveSession(subject: .spanish, daysAgo: 1, startHour: 13)
        
        saveSession(subject: .bam, daysAgo: 0, startHour: 9)
        saveSession(subject: .math, daysAgo: 0, startHour: 12)
        saveSession(subject: .compSci, daysAgo: 0, startHour: 16)
        saveSession(subject: .dev, daysAgo: 0, startHour: 20)
    }
    
    private func saveSession(subject: MockSubjects, daysAgo: Int, startHour: Int) {
        let session = buildTimeArray()
        let startDate = Calendar.current.date(bySettingHour: startHour, minute: 0, second: 0, of: getDate(daysAgo: daysAgo))!
        guard let subject = persistanceService.fetchSubject(name: subject.name()) else { return }
        
        var workingDate = startDate
        for chunk in session {
            if chunk.type == TimeTypes.work {
                 _ = persistanceService.saveSession(seconds: chunk.timeLength, date: workingDate, subject: subject)
            }
           workingDate = Calendar.current.date(byAdding: .second, value: chunk.timeLength, to: workingDate)!
        }
    }
    
    private func getDate(daysAgo: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
    }
    
    private func buildTimeArray() -> [TimeChunk] {
        let defaults = Defaults()
        let work = TimeChunk(type: TimeTypes.work, initialTime: defaults.getWorkTime())
        let short = TimeChunk(type: TimeTypes.short, initialTime: defaults.getShortTime())
        let long = TimeChunk(type: TimeTypes.long, initialTime: defaults.getLongTime())
        let numberOfSessions = defaults.getNumberOfSessions()
        var timeChunks: [TimeChunk] = Array()
        
        for session in 1...numberOfSessions {
            timeChunks.append(work)
            timeChunks.append(session == numberOfSessions ? long : short)
        }
        
        return timeChunks
    }
}

enum MockSubjects: String {
    case compSci = "Computer Science"
    case dev = "Development"
    case english = "English"
    case spanish = "Spanish"
    case math = "Math"
    case physics = "Physics"
    case bam = "Business & Management"
    
    func name() -> String {
        return self.rawValue
    }
}
