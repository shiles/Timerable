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
    func setRoundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
 
    /**
     Solution so solve the known bug that causes double hide in stack view
     */
    var isHiddenInStackView: Bool {
        get {
            return isHidden
        }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
}

extension UIViewController {

    /**
     Scroll tab bar to the right if there is one.
     */
    @objc func tabBarRight() {
        guard let tab = self.tabBarController else { return }
        let currentIndex = tab.selectedIndex
        tab.selectedIndex = currentIndex + 1
    }
    
    /**
     Scroll tab bar to the left if there is one.
     */
    @objc func tabBarLeft() {
        guard let tab = self.tabBarController else { return }
        let currentIndex = tab.selectedIndex
        tab.selectedIndex = currentIndex - 1
    }
    
}
