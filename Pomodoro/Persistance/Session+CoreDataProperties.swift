//
//  Session+CoreDataProperties.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var seconds: Int64
    @NSManaged public var catagory: Catagory?

}
