//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    let defualts: UserDefaults = UserDefaults.standard
    let pickerSet = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    @IBOutlet weak var appVertion: UILabel!
    @IBOutlet weak var workLengthButton: UIButton!
    @IBOutlet weak var shortLengthButton: UIButton!
    @IBOutlet weak var longLengthButton: UIButton!
    @IBOutlet weak var autoReset: UISwitch!
    @IBOutlet weak var sessionLengthButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Settings"
        
        //Getting up-to-date values to display
        appVertion.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        workLengthButton.setTitle(buttonTimeFormatter(seconds: defualts.getWorkTime()), for: .normal)
        shortLengthButton.setTitle(buttonTimeFormatter(seconds: defualts.getShortTime()), for: .normal)
        longLengthButton.setTitle(buttonTimeFormatter(seconds: defualts.getLongTime()), for: .normal)
        autoReset.setOn(UserDefaults.standard.getAutoReset(), animated: true)
        sessionLengthButton.setTitle(buttonSessionFormatter(sessions: defualts.getSessionLength()), for: .normal)
        
        //Setting up colours
        autoReset.onTintColor = .orange
    }
    
    @IBAction func setWorkLength(_ sender: Any) {
        let saveFn: (Int) -> Void = defualts.setWorkTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defualts.getWorkTime()), saveToDefaults: saveFn)
        newTable.title = "Work Length"        
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    @IBAction func setShortLength(_ sender: Any) {
        let saveFn: (Int) -> Void = defualts.setShortTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defualts.getShortTime()), saveToDefaults: saveFn)
        newTable.title = "Short Break Length"
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    @IBAction func setLongLength(_ sender: Any) {
        let saveFn: (Int) -> Void = defualts.setLongTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defualts.getLongTime()), saveToDefaults: saveFn)
        newTable.title = "Long Break Length"
        navigationController?.pushViewController(newTable, animated: true)
    }
    
    @IBAction func setSessionLength(_ sender: Any) {
        let actionSession = UIAlertController(title: "Set Session Length", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: .zero);
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(defualts.getSessionLength()-1, inComponent: 0, animated: false)
        actionSession.view.addSubview(pickerView)
        
        actionSession.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        self.present(actionSession, animated: true, completion: nil)
    }
    
    /**
     Flips the autoReset user defualt
     */
    @IBAction func toggleAutoReset(_ sender: Any) {
        defualts.setAutoReset(_: !defualts.getAutoReset())
    }
    
    /**
     Converts the amount of seconds into a string that can be displayed on the buttons.
     - Parameter seconds: The number of seconds to convert.
     - Returns: A formatted String `%d minutes` (rounded)
     */
    private func buttonTimeFormatter(seconds: Int) -> (String) {
        return String(format: "%d minutes", Converter.secondsToMinutes(seconds: seconds))
    }
    
    private func buttonSessionFormatter(sessions: Int) -> (String) {
        return String(format: "%d sessions", sessions)
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
        defualts.setSessionLength(Int(pickerSet[row])!)
        sessionLengthButton.setTitle(buttonSessionFormatter(sessions: defualts.getSessionLength()), for: .normal)
        print(defualts.getSessionLength())
    }
    
    
}



