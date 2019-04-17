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

    let cellReuseId = "CellId"
    let headerReuseId = "HeaderId"
    let headerHeight: CGFloat = 25
    var data: [DailyStat]!
    var headerText: String?
    var statService: StatsService!
    
    init(statService: StatsService){
        self.statService = statService
        data = statService.getLastWeeksSessionTimes()
        
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.dataSource = self
        self.delegate = self
        self.register(StatBarGraphCell.self, forCellWithReuseIdentifier: cellReuseId)
        self.register(StatBarGraphHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseId)
        
        self.headerText = buildGraphHeader(stat: data.last!)
        
        //Setting up the collection view
        self.isScrollEnabled = false
        self.allowsSelection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func reloadData() {
        data = statService.getLastWeeksSessionTimes()
        super.reloadData()
    }
    
    /**
     Builds the formatted graph header text from parameters
     - Parameter stat: The `DailyStat` thats been selected
     - Returns: A fomatted string `weekday: time`
     */
    func buildGraphHeader(stat: DailyStat) -> String {
        return String.init(format: "%@: %@", Format.dateToWeekDay(date: stat.date), Format.timeToStringWords(seconds: stat.seconds))
    }
}

extension StatBarGraph: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! StatBarGraphCell
        cell.label.text = Format.dateToShortWeekDay(date: data[indexPath.row].date)
        cell.resetBarHeight()
        
        guard let maxTime:Int = data.max()?.seconds, maxTime > 0 else { return cell }
        cell.setBarHeight(maxTime: maxTime, seconds: data[indexPath.row].seconds)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/CGFloat(data.count+2), height: self.frame.height - headerHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseId, for: indexPath) as! StatBarGraphHeaderCell
        header.label.text = self.headerText!
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.size.width, height: headerHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.headerText = buildGraphHeader(stat: data[indexPath.row])
        self.reloadData()
    }
}
