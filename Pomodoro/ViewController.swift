//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let work: Int =  25
    
    @IBOutlet weak var timeTicker: UITextField!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var timer: Timer = Timer()
    var timeRemaining: Int = 0
    var timing = false
    
    @IBAction func playPause(_ sender: Any) {
        if(!timing){
            timing = true
            playPauseButton.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        } else {
            timing = false
            playPauseButton.setTitle("Start", for: .normal)
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        timeRemaining -= 1
        timeTicker.text = String(timeRemaining)
        if(timeRemaining == 0){
            timer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeRemaining = work
    }
}
