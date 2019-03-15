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
        self.addSubview(timeViewerProgress)
        NSLayoutConstraint.activate([
            timeViewerProgress.topAnchor.constraint(equalTo: self.topAnchor),
            timeViewerProgress.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            timeViewerProgress.leftAnchor.constraint(equalTo: self.leftAnchor),
            timeViewerProgress.rightAnchor.constraint(equalTo: self.rightAnchor)])
        
        //Add the text stack and center it within the UIView
        self.addSubview(textStack)
        NSLayoutConstraint.activate([
            textStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        
        //Add Rounded Corners to UIView
        self.layer.cornerRadius = CGFloat(20.0)
        self.clipsToBounds = true
    }
    
    /**
     Updates the Time viewer with the relevant state of the session.
     - Parameter timeChunk: The `TimeChunk` to display to calulate progress and display correct label.
     */
    func updateTimeViewer(timeChunk: TimeChunk) {
        timeDisplay.text = Format.timeToString(seconds: timeChunk.timeRemaining)
        
        var text: String
        var colour: UIColor
        switch timeChunk.type {
            case .work?:
                text = "WORK"
                colour = .orange
            case .short?:
                text = "SHORT BREAK"
                colour = UIColor.red
            case .long?:
                text = "LONG BREAK"
                colour = .green
            default:
                text = "WORK"
                colour = .orange
        }
        
        sessionStatus.text = text
        let progress: Float =  Float(timeChunk.timeLength - timeChunk.timeRemaining) / Float(timeChunk.timeLength)
        self.timeViewerProgress.updatePercentage(percentage: CGFloat(progress), colour: colour)
    }
    
    lazy var timeViewerProgress: TimeViewerProgress = {
        var prog = TimeViewerProgress()
        prog.translatesAutoresizingMaskIntoConstraints = false
        return prog
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
        let time = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        time.textColor = .white
        time.textAlignment = .center
        time.font = UIFont(name: "HelveticaNeue-Light", size: 100)
        time.text = "25:00"
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    lazy var sessionStatus: UILabel = {
        let status = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        status.textColor = .white
        status.textAlignment = .center
        status.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        status.text = "WORK"
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
}
