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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SubjectCell")
        cell.textLabel?.text = ""
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
}
