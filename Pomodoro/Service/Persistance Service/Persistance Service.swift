//
//  Persistance Service.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistanceService {
    
    let persistentContainer: NSPersistentContainer!
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    /**
     Saves a new specific named subject
     - Parameter name: The name of the subject to save
     - Returns: A subject with the `name` provided
     */
    func saveSubject(name: String) -> Subject? {
        guard let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: context) as? Subject else { return nil }
        subject.name = name
        self.save()
        return subject
    }
    
    /**
     Gets a specific named subject
     - Parameters:
        - name: The name of the subject that is wanted
        - subject: The subject the session will be under
     - Returns: A subject with the `name` provided
     */
    func saveSession(seconds: Int, subject: Subject) -> Session? {
        guard let session = NSEntityDescription.insertNewObject(forEntityName: "Session", into: context) as? Session else { return nil}
        session.seconds = Int64(seconds)
        session.date = Date()
        session.subject = subject
        
        subject.addToSession(session)
        self.save()
        return session
    }
    
    /**
     Gets a list of all subjects sorted in alphabetical order.
     - Returns: List of subjects
     */
    func fetchAllSubjects() -> [Subject] {
        let request: NSFetchRequest<Subject> = Subject.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request).sorted { $0.name! < $1.name! }
        return results ?? [Subject]()
    }
    
    /**
     Gets a specific named subject
     - Parameter name: The name of the subject that is wanted
     - Returns: A subject with the `name` provided
     */
    func fetchSubject(name: String) -> Subject? {
        let request: NSFetchRequest<Subject> = Subject.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let results = ((try? persistentContainer.viewContext.fetch(request).first) as Subject??)
        return results ?? nil
    }
    
    /**
     Gets a specific subjects sessions
     - Parameter subject: The sessions subject
     - Returns: A list of sessions from the `subject` required
     */
    func fetchSessions(subject: Subject) -> [Session] {
        return subject.session?.allObjects as! [Session]
    }
    
    /**
     Gets a list of all subjects.
     - Returns: A list of all `sessions`
     */
    func fetchAllSessions() -> [Session] {
        var sessions: [Session] = []
        
        self.fetchAllSubjects().forEach {
            sessions.append(contentsOf: $0.session?.allObjects as! [Session])
        }
    
        return sessions
    }
    
    /**
     Gets a specific subjects sessions between a daterange
     - Parameters:
            start: The start date
            end: The enddate
     - Returns: A list of sessions within the date range
     */
    func fetchSessionsDateRange(start: Date, end: Date) -> [Session] {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", argumentArray: [start, end])
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? []
    }
    
    /**
     Removes all the sessions saved
     */
    func removeAllSessions() -> Void {
        fetchAllSessions().forEach { self.remove(objectID: $0.objectID) }
    }
    
    /**
     Removes the object with the given id.
     - Parameter objectID: The object's `object id`
     */
    func remove(objectID: NSManagedObjectID ) {
        let obj = context.object(with: objectID)
        context.delete(obj)
        self.save()
    }
    
    /**
     Fetch the daily goal for today, and if one doesn't exist generate it
     - Returns: Todays daily goal.
     */
    func fetchDailyGoal() -> DailyGoal {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()
        
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: start)
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", argumentArray: [start, end!])
        
        guard let goal = try? persistentContainer.viewContext.fetch(request).first else { return createDailyGoal()! }
        return goal
    }
    
    /**
     Creates a daily goal for today
     - Returns: Todays daily goal.
     */
    func createDailyGoal() -> DailyGoal? {
        guard let goal = NSEntityDescription.insertNewObject(forEntityName: "DailyGoal", into: context) as? DailyGoal else { return nil }
        goal.date = Date()
        self.save()
        return goal
    }
    
    /**
    Save the changes if there are any to the CoreData DB
     */
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}
