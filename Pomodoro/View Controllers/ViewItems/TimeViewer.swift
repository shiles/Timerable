//
//  TimeViewer.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 21/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class TimeViewer: UIView {
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        //Add view below to show progress
        self.addSubview(timeViewerBar)
        NSLayoutConstraint.activate([
            timeViewerBar.topAnchor.constraint(equalTo: self.topAnchor),
            timeViewerBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            timeViewerBar.leftAnchor.constraint(equalTo: self.leftAnchor),
            timeViewerBar.rightAnchor.constraint(equalTo: self.rightAnchor)])
        
        //Add the text stack and center it within the UIView
        self.addSubview(textStack)
        NSLayoutConstraint.activate([
            textStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        self.setRoundedCorners(radius: 20.0)
        
        //Adding accessibility features
        self.isAccessibilityElement = true
        self.accessibilityTraits = .none
    }
    
    /**
     Updates the Time viewer with the relevant state of the session.
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func updateTimeViewer(timeChunk: TimeChunk) {
        timeDisplay.text = Format.timeToString(seconds: timeChunk.timeRemaining)
        sessionStatus.text = textLabelForType(type: timeChunk.type)
        let progress: Float =  Float(timeChunk.timeLength - timeChunk.timeRemaining) / Float(timeChunk.timeLength)
        self.timeViewerBar.setProgress(progress, animated: true)
        updateAccessibilityLabel(timeChunk: timeChunk)
    }
    
    /**
     Sets the correct label to correctly explain the time remaining for accessibility
      - Parameter timeChunk: The `TimeChunk` to set the correct label.
     */
    private func updateAccessibilityLabel(timeChunk: TimeChunk) {
        self.accessibilityLabel = String.init(format: "%@ of %@ remaining", Format.timeToStringWords(seconds: timeChunk.timeRemaining), textLabelForType(type: timeChunk.type))
    }
    
    /**
     Gets the correct title to be returned for the type of text
     - Parameter type: The `TimeType` to a label for
     - Returns: A string with the correct text for the type used.
     */
    private func textLabelForType(type: TimeTypes) -> String {
        switch type {
        case .work:
            return "WORK"
        case .short:
            return "SHORT BREAK"
        case .long:
            return "LONG BREAK"
        }
    }
    
    lazy var timeViewerBar: UIProgressView = {
        let bar = UIProgressView(frame: .zero)
        bar.progressTintColor = .orange
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeDisplay, sessionStatus])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.setCustomSpacing(-5, after: timeDisplay)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var timeDisplay: UILabel = {
        let time = UILabel(frame: .zero)
        time.textColor = .white
        time.textAlignment = .center

        guard let customFont = UIFont(name: "HelveticaNeue", size: 100) else { fatalError("Font didn't load") }
        time.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        time.adjustsFontForContentSizeCategory = true
        
        time.text = "25:00"
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    lazy var sessionStatus: UILabel = {
        let status = UILabel(frame: .zero)
        status.textColor = .white
        status.textAlignment = .center
        
        let customFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        status.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        status.adjustsFontForContentSizeCategory = true
        
        status.text = "WORK"
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
}
