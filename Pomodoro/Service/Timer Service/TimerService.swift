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
 
    private(set) var timer: Timer = Timer()
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
        timeTickerDelegate.timerDecrement(timeChunk: session.first!)
        
        if defaults.getBackgroundedTime() != nil {
            fastForward(date: defaults.getBackgroundedTime()!)
        }
        
        if isChunkDone() {
            addToGoal(timeChunk: session!.first!)
            saveProgress(timeChunk: session!.removeFirst())
            timeTickerDelegate.chunkCompleted()
        }
        
        if isSessionDone() {
            stopTimer()
            session = buildTimeArray()
            timeTickerDelegate.resetTimerDisplay(timeChunk: session.first!)
            timeTickerDelegate.isFinished()
        }
    }
    
    /**
     Skips the current block of time to the next.
     */
    func skipChunk() -> Void {
        saveProgress(timeChunk: session!.removeFirst())
        notificationService.rescheduleNotifications(timeChunks: session ?? [])
        if isSessionDone(){
            stopTimer()
            session = buildTimeArray()
            timeTickerDelegate.isFinished()
        }
        timeTickerDelegate.resetTimerDisplay(timeChunk: session.first!)
    }
    
    /**
     Resets the current session
     */
    func resetSession() -> Void {
        stopTimer()
        saveProgress(timeChunk: session.first!)
        session = buildTimeArray()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session.first!)
        timeTickerDelegate.isFinished()
    }
    
    /**
     Called when settings changed but a session isn't in progress.
     */
    func setNewSessionSettings() -> Void {
        session = buildTimeArray()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session.first!)
        timeTickerDelegate.isFinished()
    }
    
    /**
     Simulates the time elapsed since the date provided and now so that the app can support being
     backgrounded and brought back into the forground.
     - Parameter backgrounded: The date that the app was backgrounded.
     */
    func fastForward(date: Date) -> Void {
        guard timer.isValid else { return }
    
        var timeElapsed = abs(Int(date.timeIntervalSinceNow))
        
        if timeElapsed >= session.reduce(0) { $0 + $1.timeRemaining } {
            //Save the whole remaining session, stop the time and reset the session.
            session.forEach {saveProgress(timeChunk: $0)}
            session.forEach {addToGoal(timeChunk: $0)}
            stopTimer()
            session = buildTimeArray()
            timeTickerDelegate.isFinished()
        } else {
            //caluclate where we are and save what we remove
            repeat {
                let chunk = session.first!
            
                if session.first!.timeRemaining < timeElapsed {
                    saveProgress(timeChunk: session.removeFirst())
                } else {
                    session[0].timeRemaining! -= timeElapsed
                }
                
                timeElapsed -= chunk.timeRemaining
            } while timeElapsed > 0
        }
        
        timeTickerDelegate.resetTimerDisplay(timeChunk: session.first!)
        defaults.removeBackgroundedTime()
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
    
    /**
     Checks to see if the session is complete and then handles the state
     - Returns: Boolean to indicate if `sessions` is done
     */
    private func isSessionDone() -> Bool {
        return session?.isEmpty ?? true
    }
    
    /**
     Checks to see if the time remaining is 0 in current chunk
     - Returns: Boolean to indicate if `timeRemaining` is 0
     */
    private func isChunkDone() -> Bool {
        return session.first!.timeRemaining == 0
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
     Saves the progess of a session to the database.
     - Parameter timeChunk: The timechunk to save
     */
    private func addToGoal(timeChunk: TimeChunk) {
        if timeChunk.type == .work {
            let goal = persistanceService.fetchDailyGoal()
            goal.sessionsCompleted += 1
            persistanceService.save()
        }
    }
}
