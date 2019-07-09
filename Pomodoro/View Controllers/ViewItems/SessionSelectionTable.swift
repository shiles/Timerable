//
//  SessionSelectionTable.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 03/04/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit

enum CalculationType {
    case session
    case daily
}

class SessionSelectionTable: UITableViewController {
    weak var delegate: UpdateSettingsLabelDelegate?
    let defaults =  Defaults()
    var data: [String]!
    var selected: Int!
    let calculationType: CalculationType!
    var saveToDefaults: (Int) -> Void 
    
    init(min: Int, max: Int, selected: Int, calculationType: CalculationType, saveToDefaults: @escaping (Int) -> Void) {
        self.selected = selected - 1
        self.saveToDefaults = saveToDefaults
        self.calculationType = calculationType

        super.init(style: .plain)
        
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
    private func generateData(min: Int, max: Int) -> [String] {
        var array: [String] = [String]()
        for number in min...max {
            array.append(String(format: (number == 1 ? "%d Work Session" : "%d Work Sessions"), number))
        }
        return array
    }
    
    /**
     Works out the length of the pomodoro session based on the current set defaults.
     - Returns: Returns the length of the current session in `seconds`
     */
    private func calculateSessionLength(numberOfSessions: Int) -> Seconds {
        var totalSeconds = 0
        
        for session in 1...numberOfSessions {
            totalSeconds += defaults.getWorkTime()
            if session != defaults.getNumberOfSessions() {
                totalSeconds += defaults.getShortTime()
            } else {
                totalSeconds += defaults.getLongTime()
            }
        }
        
        return totalSeconds
    }
    
    /**
     Gets and formats the title string to be displayed depending on what data the
     selection is for.
     - Returns: Returns the title to display for data
     */
    private func getTitle() -> String {
        if calculationType == .session {
            return String.init(format: "Total Session Time: %@", Format.timeToStringWords(seconds: calculateSessionLength(numberOfSessions: defaults.getNumberOfSessions())))
        } else {
            return String.init(format: "Total Study Time: %@", Format.timeToStringWords(seconds: calculateSessionLength(numberOfSessions: defaults.getDailyGoal())))
        }
    }
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeSelect")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.selectRow(at: IndexPath(row: self.selected, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.setSelected(true, animated: true)
        saveToDefaults(_: indexPath.row + 1)
        delegate?.updateSettingsLabels()
        
        let header = self.tableView.headerView(forSection: indexPath.section)
        header?.textLabel?.text = getTitle()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeSelect") else {
            assertionFailure("Dequeue didn't return a TableSelectCell")
            return UITableViewCell(frame: .zero)
        }
        
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitle()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.tintColor? = .orange
        header.backgroundView?.backgroundColor = .orange
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
        
        let customFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        header.textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        header.textLabel?.adjustsFontForContentSizeCategory = true
        header.textLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
