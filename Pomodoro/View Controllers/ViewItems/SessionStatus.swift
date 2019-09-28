//
//  SessionStatus.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 01/04/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class SessionStatus: UIView {
    
    //initWithFrame to init view from code
    init(title: String) {
        super.init(frame: .zero)
        setupView(title: title)
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView(title: "")
    }
    
    private func setupView(title: String) {
        self.addSubview(progress)
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: self.topAnchor),
            progress.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            progress.leftAnchor.constraint(equalTo: self.leftAnchor),
            progress.rightAnchor.constraint(equalTo: self.rightAnchor)])
        
        self.addSubview(titleLabel)
        titleLabel.text = title
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)])
        
        self.addSubview(progressText)
        NSLayoutConstraint.activate([
            progressText.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progressText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10)])
        
        self.setRoundedCorners(radius: 20.0)
        self.backgroundColor = .gray
        
        //Setup accessibility
        self.isAccessibilityElement = true
        self.accessibilityTraits = .header
    }
    
    /**
     Updates the value within the session status pane
     - Parameters:
     currentSession: The current number of sessions completed
     totalSessions: The current total sessions that the session has
     */
    func updateValues(currentSession: Int, totalSessions: Int) {
        self.progress.setProgress(Float(currentSession)/Float(totalSessions), animated: true)
        self.progressText.text = String.init(format: "%d/%d", currentSession, totalSessions)
        updateAccessibilityLabel(currentSession: currentSession, totalSessions: totalSessions)
    }
    
    /**
     Sets the correct label to correctly explain the time remaining for accessibility
     - Parameters:
     currentSession: The current number of sessions completed
     totalSessions: The current total sessions that the session has
     */
    private func updateAccessibilityLabel(currentSession: Int, totalSessions: Int) {
        var text: String
        
        switch titleLabel.text {
        case "Session": text = "Session goal"
        case "Goal": text = "Daily Goal"
        default: fatalError("Session Status Title not set correctly")
        }
        
        self.accessibilityLabel = String.init(format: "%d of %d %@ completed", currentSession, totalSessions, text)
    }
    
    lazy var titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = .white
        title.textAlignment = .center
        
        let customFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        title.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        title.adjustsFontForContentSizeCategory = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var progressText: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = .white
        title.textAlignment = .center
        
        let customFont = UIFont.systemFont(ofSize: 30, weight: .regular)
        title.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        title.adjustsFontForContentSizeCategory = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var progress: UIProgressView = { [unowned self] in
        let progress = UIProgressView(frame: self.frame)
        progress.progressTintColor = .orange
        progress.progressViewStyle = .bar
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
}
