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
    
    var data: [CellData]!
    
    init(min: Int, max: Int) {
        super.init(nibName: nil, bundle: nil)
        
        data = generateData(min: min, max: max)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Builds the allowed range of timing data to be displayed by the table
     - Parameters:
        - min: The minimum value that will be displayed by the selector
        - max: the maximum value that will be diokayed by the selector.
     - Returns: An array of CellData to be displayed.
     */
    private func generateData(min: Int, max: Int) -> [CellData] {
        var array: [CellData] = [CellData]()
        for i in stride(from: min, through: max, by: 1) {
            array.append(CellData.init(minutes: i, message: String(format: (i == 1 ? "%d minute" : "%d minutes"), i)))
        }
        return array
    }
    
    override func viewDidLoad() {
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
