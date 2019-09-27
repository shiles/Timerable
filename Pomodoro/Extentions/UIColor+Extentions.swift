//
//  UIColor+Extentions.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 22/08/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    struct Timerable {
        static let primaryColour = UIColor.orange
        static let primaryText = UIColor(named: "primaryText")
        
        static var darkModeText: UIColor {
            if #available(iOS 13.0, *) { return .label } else { return .black }
        }
        
        static var secondaryDarkModeText: UIColor {
            if #available(iOS 13.0, *) { return .secondaryLabel } else { return .darkGray }
        }
        
        static var backgroundColour: UIColor {
            if #available(iOS 13.0, *) { return .systemBackground } else { return .white }
        }
        
        static var cellBackgroundColour: UIColor {
            if #available(iOS 13.0, *) { return .secondarySystemFill } else { return .white }
        }
    }
}
