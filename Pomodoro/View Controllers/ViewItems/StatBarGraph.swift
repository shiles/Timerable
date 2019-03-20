//
//  StatBarGraph.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 20/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//
import Foundation
import UIKit

public class StatBarGraph: UITableView {

    var data: [(Date, Int)]!
    var statService: StatsService!
    
    init(statService: StatsService){
        self.statService = statService
        data = statService.getLastWeeksSessionTimes()
    
        super.init(frame: .zero, style: .plain)
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshData() {
        data = statService.getLastWeeksSessionTimes()
        self.reloadData()
    }
    
}

extension StatBarGraph: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (date, time) = data[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "StatCell")
        cell.textLabel?.text = Format.dateToWeekDay(date: date)
        return cell
    }
    
    
}
