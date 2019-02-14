//
//  MainViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 04/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class MainTabbedViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up view
        let timerView = TimerViewController()
        let timerViewNavController = UINavigationController(rootViewController: timerView)
        timerViewNavController.tabBarItem.title = "Timer"
        
        let storboard = UIStoryboard(name: "Settings", bundle: nil)
        let settings = storboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        let settingsViewNavController = UINavigationController(rootViewController: settings)
        settingsViewNavController.tabBarItem.title = "Settings"

        //Setting Delegates
        settings.settingsDelegate = timerView.timeController
        
        viewControllers = [timerViewNavController, settingsViewNavController]
    }
 
    
}
