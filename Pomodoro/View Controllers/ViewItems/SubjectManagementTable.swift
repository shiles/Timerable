//
//  SubjectManagementTable.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 19/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import CoreData
import UIKit
import Intents
import CoreSpotlight
import MobileCoreServices

protocol SubjectManagementDelegate: AnyObject {
    func reOpenActionSheet()
}

class SubjectManagementTable: UITableViewController {
    
    let persistanceService: PersistanceService!
    weak var subjectManagementDelegate: SubjectManagementDelegate?
    var subjects: [Subject]!
    
    init(persistanceService: PersistanceService, delegate: SubjectManagementDelegate?) {
        self.persistanceService = persistanceService
        self.subjectManagementDelegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        //Getting Data
        self.subjects = persistanceService.fetchAllSubjects()
        self.tableView.reloadData()
        
        //Adding add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addSubject))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Edit Subjects"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            subjectManagementDelegate?.reOpenActionSheet()
        }
    }
    
    @objc func addSubject() {
        //Donate shortcut to Siri
        let activity = ShortcutsService.newAddSubjectShortcut()
        self.userActivity = activity
        activity.becomeCurrent()
        
        let alert = UIAlertController(title: "Add Subject", message: "Add subject to be selected for study sessions", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        let action = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if self.subjectIsUnique(name: (alert.textFields?.first?.text!)!, operation: "Add") {
                guard let subject = self.persistanceService.saveSubject(name: (alert.textFields?.first?.text!)!) else { return }
                self.subjects.append(subject)
                self.subjects.sort {$0.name! < $1.name!}
                self.tableView.reloadData()
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (_, _, completion) in
            self.persistanceService.remove(objectID: self.subjects[indexPath.row].objectID)
            self.subjects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        })
        delete.image = UIImage(named: "trash")
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .destructive, title: "Edit", handler: { (_, _, completion) in
            let alert = UIAlertController(title: "Rename Subject", message: "Rename selected subject", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.text = self.subjects[indexPath.row].name
            }
            
            let action = UIAlertAction(title: "Save", style: .default, handler: { (_) in
                if self.subjectIsUnique(name: (alert.textFields?.first?.text!)!, operation: "Rename") {
                    let subject = self.subjects[indexPath.row]
                    subject.name = alert.textFields?.first?.text!
                    self.persistanceService.save()
                    self.subjects.sort {$0.name! < $1.name!}
                    self.tableView.reloadData()
                }
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        })
        edit.backgroundColor = UIColor.lightGray
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    /**
     A helper function to determine if the subject can be added/modified
     - Parameters:
     - name: The name of the subject to check if exists
     - operation: The operation being conducted to show in the error message if unsuccessful
     - Returns: if the subject can be added/modified
     */
    private func subjectIsUnique(name: String, operation: String) -> Bool {
        if self.subjects.contains(where: {subject in subject.name == name}) {
            let alert = UIAlertController(title: "Can't \(operation) Subject", message: "A subject named: \(name) already exists. Subjects must have unique names!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SubjectCell")
        cell.textLabel?.text = subjects[indexPath.row].name
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
}
