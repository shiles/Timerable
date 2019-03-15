//
//  TimerService.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 14/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

protocol TimeTickerDelegate {
    func timerDecrement(timeChunk: TimeChunk)
    func resetTimerDisplay(timeChunk: TimeChunk)
    func isFinished()
    func chunkCompleted()
}

class TimerService {
 
    var timer: Timer = Timer()
    private let defaults: Defaults!
    var timeTickerDelegate: TimeTickerDelegate!
    private let persistanceService: PersistanceService!
    private let notificationService: NotificationService!
    var session: [TimeChunk]!
    
    init(persistanceService: PersistanceService, notificationService: NotificationService, defaults: Defaults) {
        self.persistanceService = persistanceService
        self.notificationService = notificationService
        self.defaults = defaults
        self.session = buildTimeArray()
    }
    
    /**
     Starts the timer.
     */
    func startTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerService.decrementTimer), userInfo: nil, repeats: true)
        notificationService.scheduleNotifications(timeChunks: session ?? [])
    }
    
    /**
     Pauses/Stops the timer from running.
     */
    func stopTimer() -> Void {
        timer.invalidate()
        notificationService.removeNotifications()
    }
    
    /**
     Runs each time the timer fires, and decrements the timer by one and
     updates the UI through a delegate.
     */
    @objc func decrementTimer() -> Void {
        session?[0].timeRemaining -= 1
        timeTickerDelegate.timerDecrement(timeChunk: session![0])
        
        if isChunkDone() {
            saveProgress(timeChunk: session![0])
            _ = session?.removeFirst()
            timeTickerDelegate.chunkCompleted()
        }
        
        isSessionDone()
    }
    
    /**
     Skips the current block of time to the next.
     */
    func skipChunk() -> Void {
        saveProgress(timeChunk: session![0])
        _ = session?.removeFirst()
        notificationService.rescheduleNotifications(timeChunks: session ?? [])
        isSessionDone()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
    }
    
    /**
     Resets the current session
     */
    func resetSession() -> Void {
        stopTimer()
        saveProgress(timeChunk: session![0])
        session = buildTimeArray()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
        timeTickerDelegate.isFinished()
    }
    
    /**
     Checks to see if the session is complete and then handles the state
     */
    private func isSessionDone() -> Void {
        if session?.isEmpty ?? true {
            resetSession()
        }
    }
    
    /**
     Checks to see if the time remaining is 0 in current chunk
     - Returns: Boolean to indicate if `timeRemaining` is 0
     */
    private func isChunkDone() -> Bool {
        return session?[0].timeRemaining == 0
    }
    
    /**
    Saves the progess of a session to the database.
     - Parameter timeChunk: The timechunk to save
     */
    private func saveProgress(timeChunk: TimeChunk) {
        if timeChunk.type == .work {
            guard let subject = persistanceService.fetchSubject(name: defaults.getSubjectName()) else { return }
            let time = isChunkDone() ? timeChunk.timeLength : (timeChunk.timeLength - timeChunk.timeRemaining)
            _ = persistanceService.saveSession(seconds: time!, subject: subject)
        }
    }
    
    /**
     Builds the array that will be used to determine one pomeduro session based on the user settings.
     - Returns: A array of TimeChunks.
     */
    private func buildTimeArray() -> [TimeChunk]{
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

extension TimerService: SettingsDelegate {
    
    /**
     Recalculates the timechunks based on the new user defualts.
     */
    func recalculateTimeChunks() {
        session = session?.map {
            switch($0.type!){
                case .work:
                    var timeChunk = $0 as TimeChunk
                    timeChunk.timeLength = defaults.getWorkTime()
                    timeChunk.timeRemaining = defaults.getWorkTime()
                    return timeChunk
                case .short:
                    var timeChunk = $0 as TimeChunk
                    timeChunk.timeLength = defaults.getShortTime()
                    timeChunk.timeRemaining = defaults.getShortTime()
                    return timeChunk
                case .long:
                    var timeChunk = $0  as TimeChunk
                    timeChunk.timeLength = defaults.getLongTime()
                    timeChunk.timeRemaining = defaults.getLongTime()
                    return timeChunk
            }
        }
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
    }
}
