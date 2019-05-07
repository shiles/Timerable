//
//  SessionManagementController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 07/05/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

class SessionManagementController: UITableViewController {
    let subject: Subject!
    let sessions: [Session]!
    let reuseIdentifier = "DisplayCell"
    
    init(subjectName: Subject) {
        self.subject = subjectName
        self.sessions = PersistanceService().fetchSessions(subject: subject)
        super.init(style: .plain)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.navigationItem.title = subject.name
        self.tableView.register(TimeDisplayCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}
