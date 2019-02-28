//
//  Persistance Service.swift
//  Pomodoro
//
//  Created by Sonnie Hiles on 18/02/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import Foundation
import CoreData

class PersistanceService {
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "pomodoro")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /**
     Gets a list of all subjects sorted in alphabetical order.
     - Returns: List of subjects
     */
    static func getSubjects() -> [Subject] {
        do {
            let subjects: [Subject] = try PersistanceService.context.fetch(Subject.fetchRequest())
            return subjects.sorted { $0.name! < $1.name! }
        } catch {
            fatalError("Subjects fetch request failed")
        }
    }
    
    /**
     Gets a specific named subject
     - Parameter name: The name of the subject that is wanted
     - Returns: A subject with the `name` provided
     */
    static func getSubject(name: String) -> Subject {
        do {
            let request: NSFetchRequest<Subject> = Subject.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", name)
            
            return try PersistanceService.context.fetch(request).first!
        } catch {
            fatalError("Subjects fetch request failed")
        }
    }
    
    /**
     Gets a specific subjects sessions
     - Parameter subject: The sessions subject
     - Returns: A list of sessions from the `subject` required
     */
    static func getSessions(subject: Subject) -> [Session] {
        return subject.session?.allObjects as! [Session]
    }
    
    /**
     Gets a list of all subjects.
     - Returns: A list of all `sessions`
     */
    static func getAllSessions() -> [Session] {
        var sessions: [Session] = []

        PersistanceService.getSubjects().forEach {
            sessions.append(contentsOf: $0.session?.allObjects as! [Session])
        }
        
        return sessions
    }
}
