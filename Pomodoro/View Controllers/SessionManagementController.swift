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
    private let subject: Subject!
    private let sessions: [Session]!
    private var headers: [Date]?
    private let reuseIdentifier = "DisplayCell"
    
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
        self.headers = getUniqueDates(sessions: sessions)
        
        self.tableView.register(TimeDisplayCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    /**
     Gets the unique dates for to use as headers for the table
     - Parameter sessions: A list of sessions.
     - Returns: A unique list of year, month, day formatted dates.
     */
    func getUniqueDates(sessions: [Session]) -> [Date] {
        return Array(Set(sessions.map { $0.date! }.map {
            let calendar = Calendar.current
            return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0))!
        }))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Format.dateToShortDate(date: headers![section])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let session = sessions[indexPath.row]
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TimeDisplayCell else {
            assertionFailure("Dequeue didn't return a TableSelectCell")
            return TimeDisplayCell()
        }
        cell.primaryText.text = Format.dateToShortDate(date: session.date!)
        cell.secondaryText.text = Format.timeToStringWords(seconds: Int(session.seconds))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.tintColor? = .orange
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
}
