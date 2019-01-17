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
    var timeChunks: [TimeChunk]?
    var timeRemaining: Int = 70
    
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
        timeRemaining -= 1
        timeTickerDelegate.timerDecrement(secondsRemaning: timeRemaining)
        
        if(isDone()){
            stopTimer()
        }
    }
    
    /**
     Checks to see if the time remaining is 0
     - Returns: Boolean to indicate if `timeRemaining` is 0
     */
    func isDone() -> Bool {
        if(timeRemaining == 0){
            return true
        }
        return false
    }
    
    /**
     Converts from the seconts to minutes and seconds
     - Parameter seconds: An amount of *seconds* to be converted.
     - Returns: A touple (minutes, secounds).
     */
    func secondsToMinutesAndSecounds(seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
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
    func buildTimeArray(work: Int, short: Int, long: Int, sessions: Int) -> [TimeChunk]{
         var timeChunks: [TimeChunk] = Array()
        //Temporary variables to define how long a work block should be
        for i in 1...sessions {
            let work: TimeChunk = TimeChunk(type: TimeTypes.WORK, timeLength: work, timeRemaining: work
            )
            let wBreak: TimeChunk!
            //Checks weather to add a short break or a long break pased on position
            if(i != sessions){
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
