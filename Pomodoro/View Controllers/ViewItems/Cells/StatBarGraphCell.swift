//
//  StatBarGraphCell.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 21/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class StatBarGraphCell: UICollectionViewCell {
    private var barHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = UIColor.Timerable.backgroundColour
        
        //Add label to bottom of bar
        addSubview(label)
        
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)])
        
        //Add bar
        addSubview(bar)
        barHeightConstraint = bar.heightAnchor.constraint(equalToConstant: 0)
        barHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            bar.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),
            bar.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            bar.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)])
        
        //Setup accessibility
        self.isAccessibilityElement = true
        self.accessibilityTraits = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Finds the height that the bar should be.
     - Parameters:
     - dailyStat: The `maximum time` within the array.
     - seconds: The `seconds` for this bar.
     */
    func setBarHeight(maxTime: Seconds, seconds: Seconds) {
        let percentFill = CGFloat(seconds)/CGFloat(maxTime)
        self.barHeightConstraint?.constant = (self.frame.height - 45) * percentFill
        self.accessibilityValue = Format.timeToAccessibiltyWords(seconds: seconds)
    }
    
    /**
     Resets the bar height to 0
     */
    private func resetBarHeight() {
        self.barHeightConstraint?.constant = 0
        self.accessibilityValue = "0 mintues"
    }
    
    func setDay(date: Date) {
        self.accessibilityLabel = "Time studied on \(Format.dateToWeekDay(date: date))"
        label.text = Format.dateToShortWeekDay(date: date)
        self.resetBarHeight()
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray.withAlphaComponent(0.35) : UIColor.Timerable.backgroundColour
            self.accessibilityTraits = isHighlighted ? .selected : .none
        }
    }

    let label: UILabel = {
        var label = UILabel(frame: .zero)
        label.textColor = UIColor.Timerable.darkModeText
        label.textAlignment = .left
        
        let customFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bar: UIView = {
        var bar = UIView(frame: .zero)
        bar.backgroundColor = .orange
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
}
