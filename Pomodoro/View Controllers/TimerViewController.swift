//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController {

    let persistanceService: PersistanceService!
    let localNotifications: LocalNotificationService!
    let settingsController: SettingsViewController!
    let timerService: TimerService!
    let defaults = Defaults()
    var timeViewer: TimeViewer!
    var session: SessionStatus!
    var daily: SessionStatus!
    var subjects: [Subject] = []

    init(persistanceService: PersistanceService, audioNotificationController: LocalNotificationService, timerService: TimerService) {
        self.persistanceService = persistanceService
        self.localNotifications = audioNotificationController
        self.settingsController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsViewController
        self.timerService = timerService
        self.session = SessionStatus(title: "Session")
        self.daily = SessionStatus(title: "Goal")
        
        super.init(nibName: nil, bundle: nil)
        timerService.timeTickerDelegate = self
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Update session to newest setting
        if defaults.getTimerStatus() == .ready {
            timerService.setNewSessionSettings()
        }
        
        //Defualt values to show
        updateTimer(timeChunk: timerService.session![0])
        updateGoals()
    }
    
    /**
     Initially sets up the view
     */
    func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Timer"
        
        //Adding skip button
        let skipButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(self.skip))
        skipButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = skipButton
        
        //Adding settings button
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.pushSettings))
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
        
        //Adding start/stop button and status
        self.view.addSubview(timeControllButtons)
        NSLayoutConstraint.activate([
            timeControllButtons.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            timeControllButtons.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            timeControllButtons.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            timeControllButtons.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)])
        
        self.view.addSubview(sessionInfo)
        NSLayoutConstraint.activate([
            sessionInfo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            sessionInfo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            sessionInfo.topAnchor.constraint(equalTo: timeViewer.bottomAnchor, constant: 10),
            sessionInfo.bottomAnchor.constraint(equalTo: timeControllButtons.topAnchor, constant: -10)])
    }
    
    /**
     Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func updateTimer(timeChunk: TimeChunk) {
        timeViewer?.updateTimeViewer(timeChunk: timeChunk)
    }
    
    /**
     Skips the current time chunk and starts the next one
     */
    @objc func skip() {
        timerService.skipChunk()
    }
    
    /**
     Push into the settings controller.
     */
    @objc func pushSettings() {
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    /**
     Starts and stops the timer if the user needs an unexpected break
     */
    @objc func startStop() {
        switch defaults.getTimerStatus() {
        case .ready:
            let actionSession = UIAlertController(title: "Select Subject for Session", message: "Select the subject for the next session.", preferredStyle: .actionSheet)
            
            self.subjects = persistanceService.fetchAllSubjects()
            subjects.forEach { subject in
                actionSession.addAction(UIAlertAction(title: subject.name, style: .default, handler: { (_) in
                    Defaults().setSubject(subject.name!)
                    self.defaults.setTimerStatus(.timing)
                    self.timerService.startTimer()
                    self.startStopButton.setTitle("Pause", for: .normal)
                    
                    UIView.animate(withDuration: 0.20) { () -> Void in
                        self.timeControllButtons.arrangedSubviews[1].isHiddenInStackView = false
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        self.navigationItem.title = subject.name!
                    }
                }))
            }
            
            let title = subjects.isEmpty ? "Add Subject" : "Edit Subjects"
            actionSession.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
                self.navigationController?.pushViewController(SubjectManagementTable(persistanceService: self.persistanceService, delegate: self), animated: true)
            }))
            
            actionSession.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(actionSession, animated: true, completion: nil)
        case .timing:
            defaults.setTimerStatus(.paused)
            timerService.stopTimer()
            startStopButton.setTitle("Resume", for: .normal)
        case .paused:
            defaults.setTimerStatus(.timing)
            timerService.startTimer()
            startStopButton.setTitle("Pause", for: .normal)
        }
    }
    
    /**
     Resets the timer if the user wasnts to select another subject or end their current session
     */
    @objc private func reset() {
        timerService.resetSession()
        sessionFinished()
    }
    
    /**
     Resets the UI when either a session is reset or the session ends
     */
    private func sessionFinished() {
        self.navigationItem.title = "Timer"
        defaults.setTimerStatus(.ready)
        startStopButton.setTitle("Start", for: .normal)
        UIView.animate(withDuration: 0.20) { () -> Void in
            self.timeControllButtons.arrangedSubviews[1].isHiddenInStackView = true
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    /**
     Provides and updates the values in the session and goal goals panes
     */
    private func updateGoals() {
        daily.updateValues(currentSession: Int(persistanceService.fetchDailyGoal().sessionsCompleted), totalSessions: defaults.getDailyGoal())
        
        let sessionMax = defaults.getNumberOfSessions()
        let sessionCurrent = sessionMax - self.timerService.session.filter { $0.type == .work }.count
        session.updateValues(currentSession: sessionCurrent, totalSessions: sessionMax)
    }
    
    lazy var startStopButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(self.startStop), for: .touchUpInside)
        button.backgroundColor = .orange
        button.setRoundedCorners(radius: 10.0)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        button.backgroundColor = .orange
        button.setRoundedCorners(radius: 10.0)
        button.isHidden = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
    lazy var timeControllButtons: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startStopButton, resetButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 10.0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var sessionInfo: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [session, daily])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 10.0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

extension TimerViewController: TimeTickerDelegate, SubjectManagementDelegate {
   
    /**
    Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func timerDecrement(timeChunk: TimeChunk) {
        updateTimer(timeChunk: timeChunk)
    }
    
    /**
     Updates the UI when a change occures within the session
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func resetTimerDisplay(timeChunk: TimeChunk) {
        updateTimer(timeChunk: timeChunk)
        updateGoals()
    }
    
    /**
     Resets the UI when either a session is reset or the session ends
     */
    func isFinished() {
        sessionFinished()
        updateGoals()
    }
    
    /**
     Handles when a chunk is completed by the notification sound
     */
    func chunkCompleted() {
        localNotifications.playNotificationSound()
        localNotifications.playHapticFeedback()
        updateGoals()
    }
    
    /**
     Reopens the action sheet when the subject management table returns so that the user can continue
     to browse and open
     */
    func reOpenActionSheet() {
        startStop()
    }
}
