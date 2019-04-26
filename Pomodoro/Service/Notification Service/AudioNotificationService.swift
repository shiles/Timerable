//
//  AudioNotificationController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 01/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import AVFoundation

class AudioNotificationService {
    
    private let dingSound = 1104
    
    /**
     Plays the notification ping notification sound
     */
    func playNotificationSound() {
         AudioServicesPlayAlertSound(SystemSoundID(dingSound))
    }
}
