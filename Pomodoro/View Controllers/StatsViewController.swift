//
//  StatsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 26/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    var subjects: [Subject]?
    let persistanceService: PersistanceService!
    let statsService: StatsService!
    
    init(persistanceService: PersistanceService, statsService: StatsService) {
        self.persistanceService = persistanceService
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
        self.navigationItem.title = "Stats"
        
        self.view.addSubview(statStack)
        NSLayoutConstraint.activate([
            statStack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            statStack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            statStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            statStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
        //Register cells
        self.tableView.register(TimeDisplayCell.self, forCellReuseIdentifier: "TimeDisplay")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Update the data
        self.subjects = fetchSubjectsSortedByTime()
        self.tableView.reloadData()
        self.weekView.setInitialHeader()
        self.weekView.reloadData()
        
        //Donate shortcut to Siri
        let activity = StatsService.newViewStatsShortcut()
        self.userActivity = activity
        activity.becomeCurrent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let layout = weekView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.invalidateLayout()
    }
    
    /**
     Sorts the subject by time so that the highest time will be at the top, if there are no times a
     alphabetical sort is returned.
     - returns: Array of subjects sorted by overall session time
     */
    private func fetchSubjectsSortedByTime() -> [Subject] {
        return persistanceService.fetchAllSubjects().sorted { statsService.getOverallSessionTime(subject: $0) > statsService.getOverallSessionTime(subject: $1) }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        weekView.reloadData()
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
        table.register(TitleTimeHeaderCell.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        return table
    }()
    
    lazy var weekView: StatBarGraph = {
        let week = StatBarGraph(statService: statsService)
        week.backgroundColor = .white
        return week
    }()
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: .command, action: #selector(tabBarRight), discoverabilityTitle: "Scroll Tab Bar Right"),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: .command, action: #selector(tabBarLeft), discoverabilityTitle: "Scroll Tab Bar Left")]
    }
}

extension StatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let subject = subjects?[indexPath.row] else { return UITableViewCell() }
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeDisplay") as? TimeDisplayCell else {
            assertionFailure("Dequeue didn't return a TableSelectCell")
            return TimeDisplayCell()
        }
        cell.primaryText.text = subject.name
        cell.secondaryText.text = Format.timeToStringWords(seconds: statsService.getOverallSessionTime(subject: subject))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(SessionManagementController(subjectName: subjects![indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader" ) as? TitleTimeHeaderCell else {
            assertionFailure("viewForHeaderInSection didn't return a Title Header")
            return UIView()
        }
        
        headerView.updateText(primaryText: "Total Study Time:", secondaryText: String(format: "%@", Format.timeToStringWords(seconds: statsService.getTotalSessionTime())))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = .orange
    }
    
}
