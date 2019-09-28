//
//  MainViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 04/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class MainTabbedViewController: UITabBarController {
    
    let timerService: TimerService!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.timerService = TimerService()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerView = TimerViewController(timerService: timerService)
        let timerViewNavController = UINavigationController(rootViewController: timerView)
        timerViewNavController.tabBarItem.title = "Timer"
        timerViewNavController.tabBarItem.image = UIImage(named: "timer")
        
        let statView = StatsViewController()
        let statViewNavController = UINavigationController(rootViewController: statView)
        statViewNavController.tabBarItem.title = "Stats"
        statViewNavController.tabBarItem.image = UIImage(named: "bargraph")
        
        guard let settingsView = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() else { return }
        settingsView.tabBarItem.title = "Settings"
        settingsView.tabBarItem.image = UIImage(named: "settings")

        viewControllers = [timerViewNavController, statViewNavController, settingsView]
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [ UIKeyCommand(input: "1", modifierFlags: .command, action: #selector(toTimer), discoverabilityTitle: "Go To Timer Tab"),
                UIKeyCommand(input: "2", modifierFlags: .command, action: #selector(toStats), discoverabilityTitle: "Go To Stats Tab"),
                UIKeyCommand(input: "3", modifierFlags: .command, action: #selector(toSettings), discoverabilityTitle: "Go To Settings Tab")]
    }
    
    @objc func toTimer() {
        self.selectedIndex = 0
    }
    @objc func toStats() {
        self.selectedIndex = 1
    }
    
    @objc func toSettings() {
        self.selectedIndex = 2
    }
}
