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
    
    init(persistanceService: PersistanceService, statsService: StatsService) {
        self.persistanceService = persistanceService
        self.settingsController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsViewController
        self.statsService = statsService
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Initially sets up the view
     */
    func setupView() {
        self.navigationItem.title = "STATS"
        
        self.view.addSubview(statStack)
        NSLayoutConstraint.activate([
            statStack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            statStack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            statStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            statStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
        //Register cells
        self.tableView.register(TimeDisplayCell.self, forCellReuseIdentifier: "TimeDisplay")
        
        //Adding settings button
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.pushSettings))
        self.navigationItem.leftBarButtonItem = settingsButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Update the data
        self.subjects = fetchSubjectsSortedByTime()
        self.tableView.reloadData()
        self.weekView.reloadData()
    }
    
    /**
     Sorts the subject by time so that the highest time will be at the top, if there are no times a
     alphabetical sort is returned.
     - returns: Array of subjects sorted by overall session time
     */
    private func fetchSubjectsSortedByTime() -> [Subject] {
        return persistanceService.fetchAllSubjects().sorted { statsService.getOverallSessionTime(subject: $0) > statsService.getOverallSessionTime(subject: $1) }
    }
    
    /**
     Push into the settings controller.
     */
    @objc func pushSettings() {
        self.navigationController?.pushViewController(settingsController, animated: true)
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
        table.allowsSelection = false
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
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeDisplay") as? TimeDisplayCell else {
            assertionFailure("Dequeue didn't return a TableSelectCell")
            return TimeDisplayCell()
        }
        cell.primaryText.text = subject.name
        cell.secondaryText.text = Format.timeToStringWords(seconds: statsService.getOverallSessionTime(subject: subject))
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
