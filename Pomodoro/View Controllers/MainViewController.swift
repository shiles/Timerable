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
        let settingsViewNavController = UINavigationController(rootViewController: storboard.instantiateViewController(withIdentifier: "SettingsVC") as! UITableViewController)
        settingsViewNavController.tabBarItem.title = "Settings"
        
        viewControllers = [timerViewNavController, settingsViewNavController]
    }
 
    
}
