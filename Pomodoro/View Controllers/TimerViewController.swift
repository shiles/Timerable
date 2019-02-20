//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    enum SessionStates {
        case ready
        case paused
        case timing
    }
    
    let timeController: TimeController = TimeController()
    let settingsController: SettingsViewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
    var timeViewer: TimeViewer!
    var sessionStatus: SessionStates = .ready
    let catagories = ["English", "Maths"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting delegates
        timeController.timeTickerDelegate = self
        
        //Styling
        self.view.backgroundColor = .white
        
        //Adding skip button
        let skipButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(self.skip))
        self.navigationItem.rightBarButtonItem = skipButton
        
        //Adding settings button
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.pushSettings))
        settingsController.settingsDelegate = timeController
        self.navigationItem.leftBarButtonItem = settingsButton
        
        //Adding the time ticker
        timeViewer = TimeViewer(frame: .zero)
        self.view.addSubview(timeViewer)
        timeViewer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeViewer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            timeViewer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            timeViewer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            timeViewer.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
        //Adding start/stop button
        self.view.addSubview(startStopButton)
        NSLayoutConstraint.activate([
            startStopButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            startStopButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            startStopButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10)])
        
        //Defualt values to show
        updateTimer(timeChunk: timeController.session![0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "TIMER"
    }
    
    /**
     Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func updateTimer(timeChunk: TimeChunk) -> Void {
        timeViewer.updateTimeViewer(timeChunk: timeChunk)
    }
    
    /**
     Skips the current time chunk and starts the next one
     */
    @objc func skip() -> Void {
        timeController.skipChunk()
    }
    
    @objc func pushSettings() -> Void {
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    /**
     Starts and stops the timer if the user needs an unexpected break
     */
    @objc func startStop() -> Void {
        switch sessionStatus {
        case .ready:
            let actionSession = UIAlertController(title: "Select Subject for Session", message: "Select the Subject you'd like to work for within this session.", preferredStyle: .actionSheet)
            
            catagories.forEach { catagory in
                actionSession.addAction(UIAlertAction(title: catagory, style: .default, handler: { (a) in
                    UserDefaults.standard.setSubject(catagory)
                }))
            }
            
            actionSession.addAction(UIAlertAction(title: "Edit Subjects", style: .default, handler: { (a) in
                self.navigationController?.pushViewController(SubjectManagementTable(), animated: true)
            }))
            
            actionSession.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            
            self.present(actionSession, animated: true, completion: nil)
            
            sessionStatus = .timing
            timeController.startTimer()
            startStopButton.setTitle("PAUSE", for: .normal)
        case .timing:
            sessionStatus = .paused
            timeController.stopTimer()
            startStopButton.setTitle("RESUME", for: .normal)
        case .paused:
            sessionStatus = .timing
            timeController.startTimer()
            startStopButton.setTitle("PAUSE", for: .normal)
        }
    }
    
    lazy var startStopButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("START", for: .normal)
        button.addTarget(self, action: #selector(self.startStop), for: .touchUpInside)
        button.backgroundColor = .orange
        button.layer.cornerRadius = CGFloat(10.0)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

extension TimerViewController: TimeTickerDelegate {
    
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
