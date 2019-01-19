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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appVertion.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        workLengthButton.setTitle(buttonTimeFormatter(seconds: UserDefaults.standard.integer(forKey: "Work")), for: .normal)
        shortLengthButton.setTitle(buttonTimeFormatter(seconds: UserDefaults.standard.integer(forKey: "Short")), for: .normal)
        longLengthButton.setTitle(buttonTimeFormatter(seconds: UserDefaults.standard.integer(forKey: "Long")), for: .normal)
        
    }
    
    private func buttonTimeFormatter(seconds: Int) -> (String){
        return String(format: "%d minutes", Converter.secondsToMinutes(seconds: seconds))
    }
}



