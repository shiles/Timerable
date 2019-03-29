//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    let defaults = Defaults()
    let pickerSet = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    @IBOutlet weak var workLengthLabel: UILabel!
    @IBOutlet weak var shortLengthLabel: UILabel!
    @IBOutlet weak var longLengthLabel: UILabel!
    @IBOutlet weak var appVertion: UILabel!
    @IBOutlet weak var sessionLengthLabel: UILabel!
    
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
        sessionLengthLabel.text = String(format: "%d sessions", defaults.getNumberOfSessions())
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
        let actionSession = UIAlertController(title: "Set Session Length", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: .zero);
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(defaults.getNumberOfSessions()-1, inComponent: 0, animated: false)
        actionSession.view.addSubview(pickerView)
        
        actionSession.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        self.present(actionSession, animated: true, completion: nil)
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerSet[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.setNumberOfSessions(Int(pickerSet[row])!)
        sessionLengthLabel.text = String(format: "%d sessions", defaults.getNumberOfSessions())
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
            self.resetSessionsToDefaults()
        case (1, 1):
            self.resetStatistics()
        default:
            fatalError()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
