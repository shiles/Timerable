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
        super.backgroundColor = .white
        
        //Add label to bottom of bar
        addSubview(label)
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)])
        
        //Add bar
        addSubview(bar)
        barHeightConstraint = bar.heightAnchor.constraint(equalToConstant: 200)
        barHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            bar.bottomAnchor.constraint(equalTo: label.topAnchor, constant:-10),
            bar.leftAnchor.constraint(equalTo: leftAnchor),
            bar.rightAnchor.constraint(equalTo: rightAnchor)])
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
    func setBarHeight(maxTime: Int, seconds: Int) -> Void {
        let percentFill = CGFloat(seconds)/CGFloat(maxTime)
        self.barHeightConstraint?.constant = (self.frame.height-50 - label.frame.height) * percentFill
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .white
        }
    }

    let label: UILabel = {
        var label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .left
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
