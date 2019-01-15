//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeTicker: UITextField!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var timerController: TimerController = TimerController()
    var timing = false
    
    @IBAction func playPause(_ sender: Any) {
        if(!timing){
            timing = true
            playPauseButton.setTitle("Pause", for: .normal)
            timerController.startTimer()
        } else {
            timing = false
            playPauseButton.setTitle("Start", for: .normal)
            timerController.stopTimer()
        }
    }
    
    func updateTimer(secondsRemaning: Int) {
        let (m, s) = timerController.secondsToMinutesAndSecounds(seconds: secondsRemaning)
        timeTicker.text = String(format: "%02d:%02d", m, s)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerController.timeTickerDelegate = self
    }
}

extension ViewController: TimeTickerDelegate {
    func timerDecrement(secondsRemaning: Int){
        updateTimer(secondsRemaning: secondsRemaning)
    }
}
