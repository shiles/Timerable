//
//  StatBarGraphHeaderCell.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 25/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class StatBarGraphHeaderCell: UICollectionViewCell {
    private let title = TitleLabel()
    private let subtitle = SubtitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
    }
    
    func updateText(title: String, subtitle: String) {
        self.title.text = title
        self.accessibilityLabel = title
        self.subtitle .text = subtitle
        self.accessibilityValue = subtitle
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.Timerable.primaryColour
        self.addSubview(titleStack)
        NSLayoutConstraint.activate([
            titleStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleStack.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        //Setup accessibility
        self.isAccessibilityElement = true
        self.accessibilityTraits = .header
    }
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, subtitle])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
}
