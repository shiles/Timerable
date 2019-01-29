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
}

class TimeController: NSObject {
 
    var timer: Timer = Timer()
    var timeTickerDelegate: TimeTickerDelegate!
    var session: [TimeChunk]?
    
    override init() {
        super.init()
        self.session = buildTimeArray(work: 10, short: 5, long: 10, sessions: 4)
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
     Builds and setsup the study session.
     */
    func initSession(){
        session = buildTimeArray(work: 10, short: 5, long: 10, sessions: 4)
        startTimer()
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
            session?.removeFirst()
        }
        
        isSessionDone()
    }
    
    /**
     Skips the current block of time to the next.
     */
    func skipChunk() -> Void {
        session?.removeFirst()
        isSessionDone()
        timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
    }
    
    /**
     Checks to see if the session is complete and then handles the state
     */
    private func isSessionDone() -> Void {
        if session?.count == 0 {
            stopTimer()
            if UserDefaults.standard.bool(forKey: "AutoReset") == true {
                initSession()
            } else {
                session = buildTimeArray(work: 10, short: 5, long: 10, sessions: 4)
                timeTickerDelegate.resetTimerDisplay(timeChunk: session![0])
            }
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
     Builds the array that will be used to determine one pomeduro session.
     - Parameters:
        - work: The length of *work* time
        - short: The length of *short* break time
        - long: The length of *long* break time
        - sessions: The number of work *sessions* per pomodoro round
     - Returns: A array of TimeChunks.
     */
    private func buildTimeArray(work: Int, short: Int, long: Int, sessions: Int) -> [TimeChunk]{
         var timeChunks: [TimeChunk] = Array()
        //Builds the number of sessions of work / rest
        for i in 1...sessions {
            let work: TimeChunk = TimeChunk(type: TimeTypes.WORK, timeLength: work, timeRemaining: work
            )
            let wBreak: TimeChunk!
            //Checks weather to add a short break or a long break pased on position
            if i != sessions {
                wBreak = TimeChunk(type: TimeTypes.SHORT, timeLength: short, timeRemaining: short)
            } else {
                wBreak = TimeChunk(type: TimeTypes.LONG, timeLength: long, timeRemaining: long)
            }
            
            timeChunks.append(work)
            timeChunks.append(wBreak)
        }
        
        return timeChunks
    }
}
