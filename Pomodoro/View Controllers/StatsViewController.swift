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
    let persistanceService: PersistanceService!
    let statsService: StatsService!
    let settingsController: SettingsViewController!
    
    init(persistanceService: PersistanceService, statsService: StatsService, settingsController: SettingsViewController) {
        self.persistanceService = persistanceService
        self.settingsController = settingsController
        self.statsService = statsService
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding stackview
        self.view.addSubview(statStack)
        NSLayoutConstraint.activate([
            statStack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            statStack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            statStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            statStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
        self.subjects = persistanceService.fetchAllSubjects()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "STATS"
        
        //Adding data
        self.subjects = persistanceService.fetchAllSubjects()
        self.tableView.reloadData()
        self.weekView.reloadData()
    }
    
    lazy var statStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weekView, tableView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var weekView: StatBarGraph = {
        let week = StatBarGraph(statService: statsService)
        week.backgroundColor = .white
        return week
    }()
}

extension StatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = subjects[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StatCell")
        cell.textLabel?.text = subject.name
        cell.detailTextLabel?.text = Format.timeToStringWords(seconds: statsService.getOverallSessionTime(subject: subject))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "Total: %@", Format.timeToStringWords(seconds: statsService.getTotalSessionTime()))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.tintColor? = .orange
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
    
}
