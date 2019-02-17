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
        
        let statView = UIViewController()
        let statViewNavController = UINavigationController(rootViewController: statView)
        statViewNavController.tabBarItem.title = "Stats"

        viewControllers = [timerViewNavController, statViewNavController]
    }
 
    
}
