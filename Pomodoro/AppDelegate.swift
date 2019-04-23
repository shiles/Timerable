//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 13/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = Defaults()
    var main: MainTabbedViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Setting defualt values for user defualts
        defaults.registerDefaults()
        self.resetState()
  
        //Building intial view
        window = UIWindow(frame: UIScreen.main.bounds)
        main = MainTabbedViewController()
        window!.rootViewController = main
        window!.makeKeyAndVisible()
        window!.tintColor = .orange
        
        //Register to allow notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]){ (granted, error) in
            print("Notifications Granted")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if defaults.getTimerStatus() == .timing {
            defaults.setBackgroundedTime(Date())
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        main?.timerService.fastForward(date: defaults.getBackgroundedTime())
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //Fast forward then reset the session to save current progress
        main?.timerService.fastForward(date: defaults.getBackgroundedTime())
        main?.timerService.resetSession()
        saveContext()
        
        self.resetState()
    }
    
    /**
     Resets the state of the app
     */
    func resetState() -> Void {
        NotificationService().removeNotifications()
        defaults.setTimerStatus(.ready)
        defaults.removeBackgroundedTime()
    }
    
    /**
     Shows an alert to warn the users of an error in saving context
     - parameters:
     - title: title for teh error
     - reason: reason for the error
     */
    func showAlert(title: String, reason: String) -> Void {
        let error = UIAlertController(title: title, message: reason, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        main?.present(error, animated: true, completion: nil)
    }
    
    var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "pomodoro")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                let errorAlert = UIAlertController(title:"Error opening storage, can't open", message: error.userInfo.description, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                
                let window = UIWindow(frame: UIScreen.main.bounds)
                let main = MainTabbedViewController()
                window.rootViewController = main
                window.makeKeyAndVisible()
                main.present(errorAlert, animated: true, completion: nil)
                
                fatalError("Error opening pomodoro container: error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                showAlert(title: "Error saving data", reason: nserror.userInfo.description)
            }
        }
    }
}
