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
    var timeRemaining: Int = 70
    
    func startTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimeController.decrementTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void {
        timer.invalidate()
    }
    
    @objc func decrementTimer(){
        timeRemaining -= 1
        timeTickerDelegate.timerDecrement(secondsRemaning: timeRemaining)
        
        if(isDone()){
            stopTimer()
        }
    }
    
    func isDone() -> Bool {
        if(timeRemaining == 0){
            return true
        }
        return false
    }
    
    func secondsToMinutesAndSecounds(seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
