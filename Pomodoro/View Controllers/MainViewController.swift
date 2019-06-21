//
//  MainViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 04/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class MainTabbedViewController: UITabBarController {
    
    let persistanceService = PersistanceService()
    let audioNotifications = LocalNotificationService()
    let timerService: TimerService!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.timerService = TimerService(persistanceService: persistanceService, defaults: Defaults())
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerView = TimerViewController(persistanceService: persistanceService, audioNotificationController: audioNotifications, timerService: timerService)
        let timerViewNavController = UINavigationController(rootViewController: timerView)
        timerViewNavController.tabBarItem.title = "Timer"
        timerViewNavController.tabBarItem.image = UIImage(named: "timer")
        
        let statView = StatsViewController(persistanceService: persistanceService, statsService: StatsService(persistanceService: persistanceService))
        let statViewNavController = UINavigationController(rootViewController: statView)
        statViewNavController.tabBarItem.title = "Stats"
        statViewNavController.tabBarItem.image = UIImage(named: "bargraph")
        
        let settingsView = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsViewController
        let settingsViewNavController = UINavigationController(rootViewController: settingsView!)
        settingsViewNavController.tabBarItem.title = "Settings"
        settingsViewNavController.tabBarItem.image = UIImage(named: "settings")

        viewControllers = [timerViewNavController, statViewNavController, settingsViewNavController]
    }
}
