//
//  Subject+CoreDataProperties.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 25/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var name: String?
    @NSManaged public var session: NSSet?

}

// MARK: Generated accessors for session
extension Subject {

    @objc(addSessionObject:)
    @NSManaged public func addToSession(_ value: Session)

    @objc(removeSessionObject:)
    @NSManaged public func removeFromSession(_ value: Session)

    @objc(addSession:)
    @NSManaged public func addToSession(_ values: NSSet)

    @objc(removeSession:)
    @NSManaged public func removeFromSession(_ values: NSSet)

}
