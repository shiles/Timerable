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
    let audioNotifications = AudioNotificationService()
    let settingsController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerView = TimerViewController(persistanceService: persistanceService, audioNotificationController: audioNotifications, settingsController: settingsController)
        let timerViewNavController = UINavigationController(rootViewController: timerView)
        timerViewNavController.tabBarItem.title = "Timer"
        
        let statView = StatsViewController(persistanceService: persistanceService, statsService: StatsService(persistanceService: persistanceService), settingsController: settingsController)
        let statViewNavController = UINavigationController(rootViewController: statView)
        statViewNavController.tabBarItem.title = "Stats"

        viewControllers = [timerViewNavController, statViewNavController]
    }
}
