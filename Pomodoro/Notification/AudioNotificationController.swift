//
//  AudioNotificationController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 01/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import AVFoundation

class AudioNotificationController {
    
    private let dingSound = 1104
    
    /**
     Plays the notification ping notification sound
     */
    func playNotificationSound() -> Void {
         AudioServicesPlayAlertSound(SystemSoundID(dingSound))
    }
}
