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
    private let persistanceService = PersistanceService()
    private var data: [Date: [Session]]!
    private var dates: [Date]!
    private let calendar = Calendar.current
    private let reuseIdentifier = "DisplayCell"
    
    init(subjectName: Subject) {
        self.subject = subjectName
        super.init(style: .plain)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Sets up the view for display
     */
    func setupView() {
        self.navigationItem.title = subject.name
        self.refreshData()
        self.tableView.register(TimeDisplayCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //Adding edit button
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editSubject))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    /**
     Refreshes the data being displayed in the table
     */
    private func refreshData() {
        let sessions = persistanceService.fetchSessions(subject: subject)
        self.data = buildDictionary(sessions: sessions)
        self.dates = getUniqueDates(sessions: sessions)
        self.tableView.reloadData()
    }
    
    /**
     Builds a dictionary to seperate the sessions by the unique dates
     - Parameter sessions: A list of sessions.
     - Returns: A unique dictionary of date: [sessions] pairs
     */
    private func buildDictionary(sessions: [Session]) -> [Date: [Session]] {
        var data = [Date: [Session]]()
        getUniqueDates(sessions: sessions).forEach { data[$0] = filterByDate(sessions: sessions, date: $0) }
        return data
    }
    
    /**
     Gets the unique dates for to use as headers for the table
     - Parameter sessions: A list of sessions.
     - Returns: A unique list of year, month, day formatted dates.
     */
    private func getUniqueDates(sessions: [Session]) -> [Date] {
        return Array(Set(sessions.map { $0.date! }.map {
            return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0))!
        })).sorted { $0 > $1 }
    }
    
    /**
     Filters the list of sessions provided to it by date
     - Parameters:
        - sessions: A list of sessions to filter.
        - date: The date you want to filter by
     - Returns: A list of sessions that occure on a specified date
     */
    private func filterByDate(sessions: [Session], date: Date) -> [Session] {
        return sessions.filter { calendar.isDate($0.date!, inSameDayAs: date) }.sorted { $0.date! > $1.date! }
    }
    
    /**
     Subtracts a number of seconds from the date to show date started the session
     not when it was saved.
     - Parameters:
        - date: The date to subtract from
        - seconds: Number of seconds to remove
     - Returns: Date with seconds removed from it
     */
    func subtractTimeFromDate(date: Date, seconds: Seconds) -> Date {
        return calendar.date(byAdding: .second, value: -seconds, to: date)!
    }
    
    /**
     A helper function to determine if the subject can be added/modified
     - Parameters:
     - newName: The name of the subject to check if exists
     - oldName: The old name of the subject to display in the err
     - Returns: if the subject can be added/modified
     */
    private func subjectIsUnique(newName: String, oldName: String) -> Bool {
        if persistanceService.fetchAllSubjects().contains(where: {subject in subject.name == newName}) {
            let alert = UIAlertController(title: "Can't update \(oldName)", message: "A subject named: \(newName) already exists. Subjects must have unique names!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /**
     Brings up the alert box with editing options for the subject
     */
    @objc private func editSubject() {
        let alert = UIAlertController(title: "Edit \(subject.name!)", message: "Rename or delete the selected subject.", preferredStyle: .alert)
        alert.addTextField { textField in textField.text = self.subject.name! }
        
        let save = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            let newName = alert.textFields?.first?.text!
            if self.subjectIsUnique(newName: newName!, oldName: self.subject.name!) {
                self.subject.name = newName
                self.navigationItem.title = newName
                self.persistanceService.save()
            }
        })
        
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let alert = UIAlertController(title: "Delete \(self.subject.name!)", message: "Are you sure you want to delete \(self.subject.name!) and all related stats?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                self.persistanceService.remove(objectID: self.subject.objectID)
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[dates[section]]!.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Format.dateToShortDate(date: dates[section])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TimeDisplayCell else {
            assertionFailure("Dequeue didn't return a TableSelectCell")
            return TimeDisplayCell()
        }
        
        let session = data[dates[indexPath.section]]![indexPath.row]
        cell.primaryText.text = Format.dateToTime(date: self.subtractTimeFromDate(date: session.date!, seconds: Int(session.seconds)) )
        cell.secondaryText.text = Format.timeToStringWords(seconds: Int(session.seconds))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (_, _, completion) in
            self.persistanceService.remove(objectID: self.data[self.dates[indexPath.section]]![indexPath.row].objectID)
            self.refreshData()
            
            completion(true)
        })
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.Timerable.primaryText
        header.tintColor? = UIColor.Timerable.primaryColour
        header.textLabel?.textAlignment = .center
        
        let customFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        header.textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        header.textLabel?.adjustsFontForContentSizeCategory = true
        header.textLabel?.adjustsFontSizeToFitWidth = true
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.textLabel!.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            header.textLabel!.centerXAnchor.constraint(equalTo: header.centerXAnchor)])
    }
}
