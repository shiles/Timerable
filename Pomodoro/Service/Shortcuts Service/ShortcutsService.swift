//
//  ShortcutsService.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 22/06/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class ShortcutsService {
    let rootView: MainTabbedViewController!
    let defaults = Defaults()
    
    init (rootView: MainTabbedViewController) {
        self.rootView = rootView
    }

    func handleViewStats() {
        rootView.selectedIndex = 1
    }
    
    func handleAddSubject() {
        let manager = SubjectManagementTable(persistanceService: PersistanceService(), delegate: nil)
        getTimerNavController().pushViewController(manager, animated: true)
        manager.addSubject()
    }
    
    func handlePauseSession() {
        rootView?.selectedIndex = 0
        if defaults.getTimerStatus() == .timing {
            getTimerViewController().startStop()
        } else {
            showAlert(title: "Pause unavalible", reason: "The timer isn't running so there isn't anything to pause.")
        }
    }
    
    /**
    Shows an alert to warn the users of an error in saving context
    - parameters:
    - title: title for teh error
    - reason: reason for the error
    */
    private func showAlert(title: String, reason: String) {
        let error = UIAlertController(title: title, message: reason, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        rootView?.present(error, animated: true, completion: nil)
    }
    
    /**
     Gets the navigation controller that the TimerViewController is root of.
     - Returns: Navigation controller which TimerViewController is root.
     */
    private func getTimerNavController() -> UINavigationController {
        guard let timerNav = rootView?.viewControllers?.first as? UINavigationController else {
            fatalError("Shorcut Service unable to get Timer Nav controller")
        }
        return timerNav
    }
    
    /**
     Gets the TimerViewController from the hierarchy.
     - Returns: The TimerViewController that is on the stack.
     */
    private func getTimerViewController() -> TimerViewController {
        guard let timerVC = getTimerNavController().viewControllers.first as? TimerViewController else {
            fatalError("Shortcut Service unable to get TimerViewController")
        }
        return timerVC
    }
    
}
