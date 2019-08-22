//
//  TitleLabel.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 22/08/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeLabel()
    }
    
    private func initializeLabel() {
        self.textColor = UIColor.Timerable.primaryText
        self.textAlignment = .center
        
        let customFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        self.adjustsFontForContentSizeCategory = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
