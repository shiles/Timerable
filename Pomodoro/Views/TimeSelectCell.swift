//
//  TimeSelectCell.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 28/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class TableSelectCell: UITableViewCell {
    
    var minutes: Int?
    var message: String?
    
    var messageView: UILabel = {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageView)
        
        NSLayoutConstraint.activate([
            messageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            messageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            messageView.topAnchor.constraint(equalTo: self.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let message = message {
            messageView.text = message
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
