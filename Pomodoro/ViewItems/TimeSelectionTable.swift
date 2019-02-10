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
    var selected: Int!
    var saveToDefaults: (Int) -> Void 
    
    init(min: Int, max: Int, selected: Int, saveToDefaults: @escaping (Int) -> Void) {
        self.selected = selected - 1
        self.saveToDefaults = saveToDefaults
        
        super.init(nibName: nil, bundle: nil)
    
        data = generateData(min: min, max: max)
        self.tableView.allowsMultipleSelection = false
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
    
    /**
    Works out the length of the pomodoro session based on the current set defaults.
     - Returns: Returns the length of the current session in (hours, minutes, seconds)
     */
    private func calculateSessionLength() -> (Int, Int, Int) {
        let defualts = UserDefaults.standard
       
        var totalSeconds = 0

        for i in 1...defualts.getSessionLength() {
            totalSeconds += defualts.getWorkTime()
            if i != defualts.getSessionLength() {
                totalSeconds += defualts.getShortTime()
            } else {
                totalSeconds += defualts.getLongTime()
            }
        }
        
        return Converter.secondsToHoursMinutesSeconds(seconds: totalSeconds)
    }
    
    override func viewDidLoad() {
        self.tableView.register(TableSelectCell.self, forCellReuseIdentifier: "TimeSelect")
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tableView.selectRow(at: IndexPath(row: self.selected, section: 0) , animated: false, scrollPosition: UITableView.ScrollPosition.middle)
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableSelectCell
        cell.setSelected(true, animated: true)
        self.selected = indexPath.row + 1
        self.saveToDefaults(_: Converter.minutesToSeconds(minutes: selected))
        
        let (h, m ,s) = calculateSessionLength()
        print ("\(h) Hours, \(m) Minutes and \(s) Seconds")
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
