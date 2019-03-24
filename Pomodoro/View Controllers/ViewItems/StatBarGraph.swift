//
//  StatBarGraph.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 20/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//
import Foundation
import UIKit

public class StatBarGraph: UICollectionView {

    var data: [DailyStat]!
    var statService: StatsService!
    
    init(statService: StatsService){
        self.statService = statService
        data = statService.getLastWeeksSessionTimes()
    
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.dataSource = self
        self.delegate = self
        self.register(StatBarGraphCell.self, forCellWithReuseIdentifier: "CellId")
        
        //Setting up the collection view
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func reloadData() {
        data = statService.getLastWeeksSessionTimes()
        super.reloadData()
    }
}

extension StatBarGraph: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! StatBarGraphCell
        cell.label.text = Format.dateToWeekDay(date: data[indexPath.row].date)

        guard let maxTime:Int = data.max()?.seconds, maxTime > 0 else { return cell }
        cell.setBarHeight(maxTime: maxTime, seconds: data[indexPath.row].seconds)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/CGFloat(data.count+2), height: self.frame.height)
    }
}
