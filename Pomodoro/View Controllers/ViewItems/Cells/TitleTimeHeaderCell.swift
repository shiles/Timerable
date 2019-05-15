//
//  TitleTimeHeaderCell.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 03/05/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class TitleTimeHeaderCell: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
    }
    
    private func setupView() {        
        self.addSubview(titleStack)
        NSLayoutConstraint.activate([
            titleStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleStack.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        //Setup accessibility
        self.isAccessibilityElement = true
        self.accessibilityTraits = .header
    }
    
    /**
     Updates the text and the accessibility labels
     - parameters:
     primaryText: The primary bold text
     secondaryText: The subtitle
     */
    func updateText(primaryText: String, secondaryText: String) {
        self.primaryText.text = primaryText
        self.secondaryText.text = secondaryText
        self.accessibilityLabel = primaryText
        self.accessibilityValue = secondaryText
    }
    
    let primaryText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondaryText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Subtitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [primaryText, secondaryText])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
