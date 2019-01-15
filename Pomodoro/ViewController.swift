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
        timeTicker.text = String(secondsRemaning)
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
