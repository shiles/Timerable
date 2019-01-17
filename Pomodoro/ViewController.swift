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
    
    var timeController: TimeController = TimeController()
    var timing = false
    
    @IBAction func playPause(_ sender: Any) {
        if !timing {
            timing = true
            playPauseButton.setTitle("Pause", for: .normal)
            timeController.initSession()
            
        } else {
            timing = false
            playPauseButton.setTitle("Continue", for: .normal)
            timeController.stopTimer()
        }
    }
    
    func updateTimer(secondsRemaning: Int) {
        let (m, s) = timeController.secondsToMinutesAndSecounds(seconds: secondsRemaning)
        timeTicker.text = String(format: "%02d:%02d", m, s)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeController.timeTickerDelegate = self
    }
}

extension ViewController: TimeTickerDelegate {
    func timerDecrement(secondsRemaning: Int){
        updateTimer(secondsRemaning: secondsRemaning)
    }
}
