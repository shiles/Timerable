//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let defualts: UserDefaults = UserDefaults.standard

    @IBOutlet weak var appVertion: UILabel!
    @IBOutlet weak var workLengthButton: UIButton!
    @IBOutlet weak var shortLengthButton: UIButton!
    @IBOutlet weak var longLengthButton: UIButton!
    @IBOutlet weak var autoReset: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up the data within the buttons
        appVertion.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
       
        workLengthButton.setTitle(buttonTimeFormatter(seconds: defualts.getWorkTime()), for: .normal)
        shortLengthButton.setTitle(buttonTimeFormatter(seconds: defualts.getShortTime()), for: .normal)
        longLengthButton.setTitle(buttonTimeFormatter(seconds: defualts.getLongTime()), for: .normal)
        autoReset.setOn(UserDefaults.standard.getAutoReset(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Settings"
    }
    
    
    @IBAction func setWorkLength(_ sender: Any) {
        let saveFn: (Int) -> Void = defualts.setWorkTime(_:)
        
        let newTable = TimeSelectionTable(min: 1, max: 60, selected: Converter.secondsToMinutes(seconds: defualts.getWorkTime()), saveToDefaults: saveFn)
        newTable.title = "Work Length"        
        navigationController?.pushViewController(newTable, animated: true)
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
}



