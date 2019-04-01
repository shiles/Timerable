//
//  TimeViewerProgress.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 21/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class TimeViewerProgress: UIView {
    
    var percentage: CGFloat = 0.0
    var colour: UIColor = UIColor.lightGray
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.35)
    }
    /**
     Update the time viewer progress and fill the amount with a colour.
     - Parameters:
        - persentage: The percentage of the total time thats been completed
        - colour: The colour of the fill to be used
     */
    func updatePercentage(percentage: CGFloat, colour: UIColor) {
        self.percentage = percentage
        self.colour = colour
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let fill = CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width*percentage, height: rect.size.height)
        colour.set()
        UIRectFill(fill)
    }
}
