//
//  TimerController.swift
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
}

class TimeController: NSObject {
 
    var timer: Timer = Timer()
    let defaults = UserDefaults.standard
    var timeTickerDelegate: TimeTickerDelegate!
    var session: [TimeChunk]?
    
    override init() {
        super.init()
        self.session = buildTimeArray()
    }
    
    /**
     Starts the timer.
     */
    func startTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimeController.decrementTimer), userInfo: nil, repeats: true)
    }
    
    /**
     Pauses/Stops the timer from running.
     */
    func stopTimer() -> Void {
        timer.invalidate()
    }
    
    /**
     Runs each time the timer fires, and decrements the timer by one and
     updates the UI through a delegate.
     */
    @objc func decrementTimer() -> Void {
        session?[0].timeRemaining -= 1
        timeTickerDelegate.timerDecrement(timeChunk: session![0])
        
        //Remove the time chunk if theres not time remaining
        if isChunkDone() {
            if session![0].type == .WORK {
                 saveProgress(secondsComplete: session![0].timeLength)
            }
            session?.removeFirst()
        }
        
        isSessionDone()
    }
    
    /**
     Skips the current block of time to the next.
     */
    func skipChunk() -> Void {
        _ = session?.removeFirst()
        isSessionDone()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
    }
    
    /**
     Resets the current session
     */
    func resetSession() -> Void {
        stopTimer()
        session = buildTimeArray()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
        timeTickerDelegate.isFinished()
    }
    
    /**
     Checks to see if the session is complete and then handles the state
     */
    private func isSessionDone() -> Void {
        if session?.count == 0 {
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
     - Parameter secondsComplete: The seconds completed within that session
     */
    private func saveProgress(secondsComplete: Int) {
        let subject = PersistanceService.getSubject(name: defaults.getSubjectName())
        
        let session = Session(context: PersistanceService.context)
        session.seconds = Int64(secondsComplete)
        session.date = Date() as NSDate
        session.subject = subject
        
        subject.addToSession(session)
        
        PersistanceService.saveContext()
    }
    
    /**
     Builds the array that will be used to determine one pomeduro session based on the user settings.
     - Returns: A array of TimeChunks.
     */
    private func buildTimeArray() -> [TimeChunk]{
        let work: Int = defaults.getWorkTime()
        let short: Int = defaults.getShortTime()
        let long: Int = defaults.getLongTime()
        let sessions = defaults.getSessionLength()
        
        var timeChunks: [TimeChunk] = Array()
        //Builds the number of sessions of work / rest
        for i in 1...sessions {
            let workTime: TimeChunk = TimeChunk(type: TimeTypes.WORK, timeLength: work, timeRemaining: work
            )
            let workBreak: TimeChunk!
            //Checks weather to add a short break or a long break pased on position
            if i != sessions {
                workBreak = TimeChunk(type: TimeTypes.SHORT, timeLength: short, timeRemaining: short)
            } else {
                workBreak = TimeChunk(type: TimeTypes.LONG, timeLength: long, timeRemaining: long)
            }
            
            timeChunks.append(workTime)
            timeChunks.append(workBreak)
        }
        
        return timeChunks
    }
}

extension TimeController: SettingsDelegate {
    
    /**
     Recalculates the timechunks based on the new user defualts.
     */
    func recalculateTimeChunks() {
        session = session?.map {
            switch($0.type){
                case .WORK?:
                    var timeChunk = $0
                    timeChunk.timeLength = defaults.getWorkTime()
                    timeChunk.timeRemaining = defaults.getWorkTime()
                    return timeChunk
                case .SHORT?:
                    var timeChunk = $0
                    timeChunk.timeLength = defaults.getShortTime()
                    timeChunk.timeRemaining = defaults.getShortTime()
                    return timeChunk
                case .LONG?:
                    var timeChunk = $0
                    timeChunk.timeLength = defaults.getLongTime()
                    timeChunk.timeRemaining = defaults.getLongTime()
                    return timeChunk
                case .none:
                    return $0
            }
        }
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
    }
}
