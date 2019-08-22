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
    let headerHeight: CGFloat = 45
    var data: [DailyStat]!
    var headerText: String?
    var statService: StatsService!
    
    init(statService: StatsService) {
        self.statService = statService
        data = statService.getLastWeeksSessionTimes()
        
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        super.init(frame: .zero, collectionViewLayout: flow)
        self.dataSource = self
        self.delegate = self
        self.register(StatBarGraphCell.self, forCellWithReuseIdentifier: cellReuseId)
        self.register(StatBarGraphHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseId)
        
        setInitialHeader()
        
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
     Sets the initial header for the graph, on today
     */
    func setInitialHeader() {
         data = statService.getLastWeeksSessionTimes()
         self.headerText = buildGraphHeader(stat: data.last!)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as? StatBarGraphCell else {
            assertionFailure("Dequeue didn't return a StatBarGraphCell")
            return StatBarGraphCell(frame: .zero)
        }
        
        cell.setDay(date: data[indexPath.row].date)
        
        guard let maxTime: Int = data.max()?.seconds, maxTime > 0 else { return cell }
        cell.setBarHeight(maxTime: maxTime, seconds: data[indexPath.row].seconds)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor(frame.size.width/CGFloat(data.count)), height: frame.size.height - headerHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseId, for: indexPath) as? StatBarGraphHeaderCell else {
             assertionFailure("DequeueSupplementaryView didn't return a StatBarGraphHeaderCell")
            return StatBarGraphHeaderCell(frame: .zero)
        }
        
        header.updateText(title: "Last 7 Days:", subtitle: self.headerText!)
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
