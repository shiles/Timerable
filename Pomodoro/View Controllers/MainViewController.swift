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
         
        
        viewControllers = [timerViewNavController]
    }
 
    
}
