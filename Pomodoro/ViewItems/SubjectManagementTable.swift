//
//  SubjectManagementTable.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 19/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit
import CoreData

class SubjectManagementTable: UITableViewController {
    var subjects: [Subject]!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        //Getting Data
        let fetchRequest:  NSFetchRequest<Subject> = Subject.fetchRequest()
        do {
            self.subjects = try PersistanceService.context.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch {
            fatalError("Subjects fetch request failed")
        }
        
        //Adding add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addSubject))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addSubject() {
        let alert = UIAlertController(title: "Add Subject", message: "Add subject to be selected for study sessions", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        let action = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            let subject = Subject(context: PersistanceService.context)
            subject.name = alert.textFields?.first?.text!
            PersistanceService.saveContext()
            self.subjects.append(subject)
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Edit Subjects"
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
            PersistanceService.context.delete(self.subjects[indexPath.row])
            self.subjects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        })
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .destructive, title: "Edit", handler: { (action, view, completion) in
            let alert = UIAlertController(title: "Add Subject", message: "Add subject to be selected for study sessions", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.text = self.subjects[indexPath.row].name
            }
            
            let action = UIAlertAction(title: "Save", style: .default, handler: { (_) in
                let subject = self.subjects[indexPath.row]
                subject.name = alert.textFields?.first?.text!
                PersistanceService.saveContext()
                self.tableView.reloadData()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        })
        edit.backgroundColor = UIColor.lightGray
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
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
