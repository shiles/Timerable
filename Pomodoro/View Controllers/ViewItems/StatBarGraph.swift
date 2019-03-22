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

    var data: [DailyStat] = [DailyStat(date: Date(), seconds: 1341), DailyStat(date: Date(), seconds: 123), DailyStat(date: Date(), seconds: 467), DailyStat(date: Date(), seconds: 534), DailyStat(date: Date(), seconds: 876), DailyStat(date: Date(), seconds: 1234)]
    var statService: StatsService!
    
    init(statService: StatsService){
        self.statService = statService
        //data = statService.getLastWeeksSessionTimes()
        
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.dataSource = self
        self.delegate = self
        self.register(StatBarGraphCell.self, forCellWithReuseIdentifier: "CellId")
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatBarGraph: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Added the +2 as that is the width required to add passing in a way that shows all of the information.
        return CGSize(width: self.frame.width/CGFloat(data.count+2), height: self.frame.height)
    }
}
