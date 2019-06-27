//
//  SiriViewController.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 25/06/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit
import IntentsUI

class SiriViewController: UITableViewController {
    private let reuseIdentifier = "SiriCell"
    private let avalibleShortcuts: [NSUserActivity] = [
        ShortcutsService.pauseSessionShortcut(),
        ShortcutsService.resumeSessionShortcut(),
        ShortcutsService.skipChunkSessionShortcut(),
        ShortcutsService.resetSessionShortcut(),
        ShortcutsService.newAddSubjectShortcut(),
        ShortcutsService.newViewStatsShortcut()
    ]
    
    init() {
        super.init(style: .plain)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.tableView.register(SiriShortcutCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Shortcuts"
        self.tableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SiriShortcutCell(style: .default, reuseIdentifier: "SubjectCell")
        let shortcut = avalibleShortcuts[indexPath.row]
        cell.titleText.text = shortcut.title
        cell.subtitleText.text = shortcut.contentAttributeSet?.contentDescription
        cell.siriButton.shortcut = INShortcut(userActivity: shortcut)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avalibleShortcuts.count
    }
}
