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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeSelect") as! TableSelectCell
        cell.message = data[indexPath.row].message
        cell.minutes = data[indexPath.row].minutes
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let (h, m ,s) = calculateSessionLength()
        
        let description = UILabel(frame: .zero)
        description.text = "The total session time is:"
        description.translatesAutoresizingMaskIntoConstraints = false
        
        let timeRemaining = UILabel(frame: .zero)
        timeRemaining.text = "\(h) Hours, \(m) Minutes and \(s) Seconds"
        timeRemaining.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [description, timeRemaining])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
       
//        NSLayoutConstraint.activate([
//            totalSessionTime.topAnchor.constraint(equalTo: headerView.topAnchor),
//            totalSessionTime.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
//            totalSessionTime.leftAnchor.constraint(equalTo: headerView.leftAnchor),
//            totalSessionTime.rightAnchor.constraint(equalTo: headerView.rightAnchor)])
//
        return stack
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
