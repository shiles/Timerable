//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timeController: TimeController = TimeController()
    var timeViewer: TimeViewer!
    var timing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting delegates
        timeController.timeTickerDelegate = self
        
        //Adding skip button
        let skipButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(self.skip))
        self.navigationItem.rightBarButtonItem = skipButton
        
        //Adding the time ticker
        timeViewer = TimeViewer(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(timeViewer)
        timeViewer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeViewer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            timeViewer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            timeViewer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            timeViewer.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
        //Defualt values to show
        updateTimer(timeChunk: timeController.session![0])
        timeController.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "TIMER"
    }
    
    @objc func skip() -> Void {
        timeController.skipChunk()
    }
    
    /**
     Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func updateTimer(timeChunk: TimeChunk) -> Void {
        timeViewer.updateTimeViewer(timeChunk: timeChunk)
    }
}

extension ViewController: TimeTickerDelegate {
    
    /**
    Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func timerDecrement(timeChunk: TimeChunk){
        updateTimer(timeChunk: timeChunk)
    }
    
    /**
     Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func resetTimerDisplay(timeChunk: TimeChunk) {
        updateTimer(timeChunk: timeChunk)
    }
}
