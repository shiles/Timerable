//
//  LocalNotificationService.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 01/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class LocalNotificationService {
    
    private let dingSound = 1104
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    /**
     Plays the notification ping notification sound
     */
    func playNotificationSound() {
         AudioServicesPlayAlertSound(SystemSoundID(dingSound))
    }
    
    /**
     Runs the haptic engine with a success to show you've completed the block
     of work
     */
    func playHapticFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.success)
    }
    
}
