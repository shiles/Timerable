//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/01/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var appVertion: UILabel!
    @IBOutlet weak var workLengthButton: UIButton!
    @IBOutlet weak var shortLengthButton: UIButton!
    @IBOutlet weak var longLengthButton: UIButton!
    @IBOutlet weak var autoReset: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up the data within the buttons
        appVertion.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        workLengthButton.setTitle(buttonTimeFormatter(seconds: UserDefaults.standard.integer(forKey: "Work")), for: .normal)
        shortLengthButton.setTitle(buttonTimeFormatter(seconds: UserDefaults.standard.integer(forKey: "Short")), for: .normal)
        longLengthButton.setTitle(buttonTimeFormatter(seconds: UserDefaults.standard.integer(forKey: "Long")), for: .normal)
        autoReset.setOn(UserDefaults.standard.bool(forKey: "AutoReset"), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "SETTINGS"
    }
    
    /**
     Flips the autoReset user defualt
     */
    @IBAction func toggleAutoReset(_ sender: Any) {
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "AutoReset"), forKey: "AutoReset")
    }
    
    /**
     Converts the amount of seconds into a string that can be displayed on the buttons.
     - Parameter seconds: The number of seconds to convert.
     - Returns: A formatted String `%d minutes` (rounded)
     */
    private func buttonTimeFormatter(seconds: Int) -> (String){
        return String(format: "%d minutes", Converter.secondsToMinutes(seconds: seconds))
    }
}



