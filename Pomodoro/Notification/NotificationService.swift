//
//  NotificationService.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 11/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    
    /**
     Schedules the nofications at all the times where the timechunks change state.
     - Parameter value: The session to set the array for.
     */
    func scheduleNotifications(timeChunks: [TimeChunk]) -> Void {
        print("Scheduling Notifications")
        var notificationTime = Date()
        for chunk in timeChunks {
            
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            
            //Add content to the notification
            switch chunk.type! {
            case .work:
                content.title = "Back to work!"
                content.body = "Time to work, don't worry its only \(Format.timeToStringWords(seconds: chunk.timeRemaining))!"
            case .short:
                content.title = "Short Break!"
                content.body = "Time for a quick \(Format.timeToStringWords(seconds: chunk.timeRemaining)) break; Get up and have a walk, check your phone or whatever you got to do!"
            case .long:
                content.title = "Long Break!"
                content.body = "Time for a long break, you get \(Format.timeToStringWords(seconds: chunk.timeRemaining)) before it all starts again."
            }
        
            let calendar = Calendar.current
            var time = DateComponents()
            time.hour = calendar.component(.hour, from: notificationTime)
            time.minute = calendar.component(.minute, from: notificationTime)
            time.second = calendar.component(.second, from: notificationTime)

            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            //Get time that next time chunk starts
            notificationTime += TimeInterval(exactly: chunk.timeLength)!
        }
    }
}
