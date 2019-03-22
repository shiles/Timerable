//
//  StatBarGraphCell.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 21/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class StatBarGraphCell: UICollectionViewCell {
    
    var barHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .lightGray
        //Add bar
        addSubview(bar)
        
        barHeightConstraint = bar.heightAnchor.constraint(equalToConstant: 200)
        barHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            bar.bottomAnchor.constraint(equalTo: bottomAnchor),
            bar.leftAnchor.constraint(equalTo: leftAnchor),
            bar.rightAnchor.constraint(equalTo: rightAnchor)])
        
        //Add label to bottom of bar
        addSubview(label)
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        var label = UILabel(frame: .zero)
        label.text = "MON"
        label.textColor = .black
        label.textAlignment = .center
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
