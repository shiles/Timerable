//
//  Extentions.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 17/04/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     Rounds the corner of the uiview that calls the function
     - Parameter radius: Radius of the rounded corner
     */
    func setRoundedCorners(radius: CGFloat) -> Void {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
}
