//
//  StatsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 26/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    var subjects: [Subject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding stackview
        self.view.addSubview(statStack)
        NSLayoutConstraint.activate([
            statStack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            statStack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            statStack.topAnchor.constraint(equalTo: self.view.topAnchor),
            statStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        
        self.subjects = PersistanceService.getSubjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "STATS"
        
        //Adding data
        self.subjects = PersistanceService.getSubjects()
        self.tableView.reloadData()
    }
    
    /**
    Gets all the sessions from a subject and sums the time spent on that subject
     - Parameter subject: The `subject` you want to know the overall time for
     - Returns: Sum of time time spend in `subject`
     */
    private func getOverallSessionTime(subject: Subject) -> Int {
        let sessions: [Session] = PersistanceService.getSessions(subject: subject)
        return Int(sessions.reduce(0) { $0 + $1.seconds })
    }
    
    lazy var statStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tableView])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.dataSource = self
        return table
    }()
}

extension StatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = subjects[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StatCell")
        cell.textLabel?.text = subject.name
        cell.detailTextLabel?.text = Format.timeToStringWords(seconds: getOverallSessionTime(subject: subject))
        return cell
    }
    
}
