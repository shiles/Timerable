//
//  Catagory+CoreDataProperties.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//
//

import Foundation
import CoreData


extension Catagory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catagory> {
        return NSFetchRequest<Catagory>(entityName: "Catagory")
    }

    @NSManaged public var name: String?
    @NSManaged public var session: Session?

}
