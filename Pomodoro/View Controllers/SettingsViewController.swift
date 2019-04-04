//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
   
    let defaults = Defaults()
    
    @IBOutlet weak var workLengthLabel: UILabel!
    @IBOutlet weak var shortLengthLabel: UILabel!
    @IBOutlet weak var longLengthLabel: UILabel!
    @IBOutlet weak var appVertion: UILabel!
    @IBOutlet weak var sessionLengthLabel: UILabel!
    @IBOutlet weak var dailyGoalLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Settings"
        
        //Getting up-to-date values to display
        appVertion.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        setLabelsToDefualtsValues()
    }
    
    private func setLabelsToDefualtsValues() {
        workLengthLabel.text = Format.timeToStringWords(seconds: defaults.getWorkTime())
        shortLengthLabel.text = Format.timeToStringWords(seconds: defaults.getShortTime())
        longLengthLabel.text = Format.timeToStringWords(seconds: defaults.getLongTime())
        sessionLengthLabel.text = String(format: "%d work sessions", defaults.getNumberOfSessions())
        dailyGoalLabel.text = String(format: "%d work sessions", defaults.getDailyGoal())
    }

    private func setWorkLength() {
        let saveFn: (Int) -> Void = defaults.setWorkTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defaults.getWorkTime()), saveToDefaults: saveFn)
        newTable.title = "Work Length"        
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    private func setShortLength() {
        let saveFn: (Int) -> Void = defaults.setShortTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defaults.getShortTime()), saveToDefaults: saveFn)
        newTable.title = "Short Break Length"
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    private func setLongLength() {
        let saveFn: (Int) -> Void = defaults.setLongTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defaults.getLongTime()), saveToDefaults: saveFn)
        newTable.title = "Long Break Length"
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    private func setSessionLength() {
        let saveFn: (Int) -> Void = defaults.setNumberOfSessions(_:)
        
        let newTable = SessionSelectionTable(min: 1, max: 10, selected: defaults.getNumberOfSessions(), calculationType: .session, saveToDefaults: saveFn)
        newTable.title = "Length of Session"
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    private func setDailyGoals() {
        let saveFn: (Int) -> Void = defaults.setDailyGoal(_:)
        
        let newTable = SessionSelectionTable(min: 1, max: 30, selected: defaults.getDailyGoal(), calculationType: .daily, saveToDefaults: saveFn)
        newTable.title = "Daily Work Sessions Goal"
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    private func resetSessionsToDefaults() {
         let warning = UIAlertController(title: "Reset Session Settings To Defualts", message: "Are you sure you want to reset the sessions settings back to the defualts?", preferredStyle: .alert)
        
        warning.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            self.defaults.resetToDefaults()
            self.setLabelsToDefualtsValues()
        }))
        warning.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(warning, animated: true, completion: nil)
    }
    
    private func resetStatistics() {
        let warning = UIAlertController(title: "Reset Statistics", message: "Are you sure you want to delete all of the current statistics?", preferredStyle: .alert)
        
        warning.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            PersistanceService().removeAllSessions()
        }))
        warning.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(warning, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0) :
            self.setWorkLength()
        case (0, 1):
            self.setShortLength()
        case (0, 2):
            self.setLongLength()
        case (0, 3):
            self.setSessionLength()
        case (1, 0):
            self.setDailyGoals()
        case (2, 0):
            self.resetSessionsToDefaults()
        case (2, 1):
            self.resetStatistics()
        default:
            fatalError()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
