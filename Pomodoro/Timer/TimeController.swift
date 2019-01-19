//
//  TimerController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 14/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation

protocol TimeTickerDelegate {
    func timerDecrement(secondsRemaning:Int)
}

class TimeController: NSObject {
 
    var timer: Timer = Timer()
    var timeTickerDelegate: TimeTickerDelegate!
    var session: [TimeChunk]?
    
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
        timeTickerDelegate.timerDecrement(secondsRemaning: session?[0].timeRemaining ?? 0)
        
        //Remove the time chunk if theres not time remaining
        if isChunkDone() {
            session?.removeFirst()
        }
        
        if isSessionDone() {
            stopTimer()
        }
    }
    
    /**
     Checks to see if the session is complete
     - Returns: Boolean to indicate if `timeRemaining` is 0
     */
    fileprivate func isSessionDone() -> Bool {
        if session?.count == 0 {
            return true
        }
        return false
    }
    
    /**
     Checks to see if the time remaining is 0 in current chunk
     - Returns: Boolean to indicate if `timeRemaining` is 0
     */
    fileprivate func isChunkDone() -> Bool {
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
    fileprivate func buildTimeArray(work: Int, short: Int, long: Int, sessions: Int) -> [TimeChunk]{
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
