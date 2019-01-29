//
//  TimeSelectionTable.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 27/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

struct CellData {
    let minutes: Int?
    let message: String?
}

class TimeSelectionTable: UITableViewController {
    
    var data: [CellData] = [CellData]()
    
    override func viewDidLoad() {
        data = [CellData.init(minutes: 1, message: "1 Minute"), CellData.init(minutes: 2, message: "2 Minutes")]
        
        self.tableView.register(TableSelectCell.self, forCellReuseIdentifier: "TimeSelect")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeSelect") as! TableSelectCell
        cell.message = data[indexPath.row].message
        cell.minutes = data[indexPath.row].minutes
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
