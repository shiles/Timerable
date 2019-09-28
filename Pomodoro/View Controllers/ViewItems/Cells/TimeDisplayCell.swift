//
//  TimeDisplayCell.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 10/04/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class TimeDisplayCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpCell()
    }
    
    /**
     Initially sets up the view
     */
    private func setUpCell() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(primaryText)
        self.addSubview(secondaryText)
        NSLayoutConstraint.activate([
            primaryText.centerYAnchor.constraint(equalTo: centerYAnchor),
            primaryText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            secondaryText.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondaryText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            primaryText.trailingAnchor.constraint(lessThanOrEqualTo: secondaryText.leadingAnchor, constant: -15)])
    }
    
    let primaryText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondaryText: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
    
        let customFont = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
