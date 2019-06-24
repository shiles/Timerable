//
//  ShortcutsService.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 22/06/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit
import Intents
import CoreSpotlight
import MobileCoreServices

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
    
    func handleSkipChunk() {
        rootView?.selectedIndex = 0
        if defaults.getTimerStatus() != .ready {
            getTimerViewController().skip()
        } else {
            showAlert(title: "Skip unavalible", reason: "There is no active focus session, so there isn't anything to skip.")
        }
    }
    
    func handleResetSession() {
        rootView?.selectedIndex = 0
        if defaults.getTimerStatus() != .ready {
            getTimerViewController().reset()
        } else {
            showAlert(title: "Reset unavalible", reason: "There is no active focus session, so there isn't anything to reset.")
        }
    }
    
    func handleResumeSession() {
        rootView?.selectedIndex = 0
        if defaults.getTimerStatus() == .paused {
            getTimerViewController().startStop()
        } else {
            showAlert(title: "Resume unavalible", reason: "The timer isn't paused so there isn't anything to resume.")
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
    
    /**
     Builds a templated shortcut to pause the current session if one is running
     - Returns: NSUserActivity for pausing current session
     */
    public static func pauseSessionShortcut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "com.Pomodoro.pause-session")
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Pause Focus Session"
        activity.suggestedInvocationPhrase = "Pause focus session"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = UIImage(named: "thumbnail")?.pngData()
        attributes.contentDescription = "Pause the current focus session"
        activity.contentAttributeSet = attributes
        
        return activity
    }
    
    /**
     Builds a templated shortcut to pause the current session if one is running
     - Returns: NSUserActivity for pausing current session
     */
    public static func resumeSessionShortcut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "com.Pomodoro.resume-session")
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Resume Focus Session"
        activity.suggestedInvocationPhrase = "Resume focus session"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = UIImage(named: "thumbnail")?.pngData()
        attributes.contentDescription = "Resume the current focus session"
        activity.contentAttributeSet = attributes
        
        return activity
    }
    
    /**
     Builds a templated shortcut to skip the chunk in the active session
     - Returns: NSUserActivity for pausing current session
     */
    public static func skipChunkSessionShortcut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "com.Pomodoro.skip-chunk")
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Skip Focus Chunk"
        activity.suggestedInvocationPhrase = "Skip focus chunk"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = UIImage(named: "thumbnail")?.pngData()
        attributes.contentDescription = "Skip the remaining time in the current focus chunk"
        activity.contentAttributeSet = attributes
        
        return activity
    }
    
    /**
     Builds a templated shortcut to reset the active session
     - Returns: NSUserActivity for pausing current session
     */
    public static func resetSessionShortcut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "com.Pomodoro.reset-session")
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Reset Focus Session"
        activity.suggestedInvocationPhrase = "Reset focus session"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = UIImage(named: "thumbnail")?.pngData()
        attributes.contentDescription = "Reset the current focus session"
        activity.contentAttributeSet = attributes
        
        return activity
    }
    
    /**
     Builds a templated shortcut to open the stats pane of the tab bar
     - Returns: NSUserActivity for opening the stats menu.
     */
    public static func newViewStatsShortcut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "com.Pomodoro.view-stats")
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "View Focus Stats"
        activity.suggestedInvocationPhrase = "View Stats"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = UIImage(named: "thumbnail")?.pngData()
        attributes.contentDescription = "View stats about your focused work sessions!"
        activity.contentAttributeSet = attributes
        
        return activity
    }
    
}
