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
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
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
        
        //Add Rounded Corners to UIView
        self.layer.cornerRadius = CGFloat(20.0)
        self.clipsToBounds = true
    }
    
    func updateValues(currentSession: Int, totalSessions: Int) -> Void {
        self.progress.setProgress(Float(currentSession)/Float(totalSessions), animated: true)
        self.progressText.text = String.init(format: "%d/%d", currentSession, totalSessions)
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    lazy var titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = .white
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var progressText: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = .white
        title.textAlignment = .center
        title.font = UIFont(name: "HelveticaNeue", size: 30)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var progress: UIProgressView = {
        let progress = UIProgressView(frame: .zero)
        progress.progressTintColor = .orange
        progress.backgroundColor = UIColor.lightGray.withAlphaComponent(0.35)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
}
