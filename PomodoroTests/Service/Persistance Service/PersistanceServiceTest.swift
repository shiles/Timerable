//
//  PersistanceServiceTest.swift
//  PomodoroTests
//
//  Created by Sonnie Hiles on 01/03/2019.
//  Copyright © 2019 Sonnie Hiles. All rights reserved.
//

import XCTest
import CoreData
@testable import Pomodoro

class PersistanceServiceTest: XCTestCase {

    var service: PersistanceService!

    override func setUp() {
        super.setUp()
        initStubs()
        service = PersistanceService(container: mockPersistantContainer)
    }

    override func tearDown() {
        flushData()
    }

    func testSaveSubject() {
        let subject = service.saveSubject(name: "Spanish")
        XCTAssertNotNil(subject)
    }
    
    func testSaveSession() {
        let subject = service.saveSubject(name: "Physics")
        let session = service.saveSession(seconds: 60, subject: subject!)
        XCTAssertNotNil(session)
    }
    
    func testFetchAllSubjects() {
        let results = service.fetchAllSubjects()
        XCTAssertEqual(results.count, 3)
    }
    
    func testFetchSubject() {
        let name = "English"
        let session = service.fetchSubject(name: name)
        XCTAssertEqual(session?.name, name)
    }
    
    func testFetchSessions() {
        let subject = service.saveSubject(name: "CS")
        _ = service.saveSession(seconds: 60, subject: subject!)
        
        let results = service.fetchSessions(subject: subject!)
        XCTAssertEqual(results.count, 1)
    }
    
    func testFetchAllSessions() {
        let subject = service.saveSubject(name: "CS")
        _ = service.saveSession(seconds: 60, subject: subject!)
        
        let results = service.fetchAllSessions()
        XCTAssertEqual(results.count, 1)
    }
    
    func testFetchSessionsDateRange() {
        let subject = service.saveSubject(name: "CS")
        _ = service.saveSession(seconds: 60, subject: subject!)
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
        
        let results = service.fetchSessionsDateRange(start: startDate, end: endDate)
        XCTAssertEqual(results.count, 1)
    }
    
    func testRemove() {
        _ = service.saveSubject(name: "Security")
        let subjects = service.fetchAllSubjects()
        
        let delete = subjects[0]
        let numberOfItems = subjects.count
        
        service.remove(objectID: delete.objectID)
        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfItems-1)
        
    }
    
    func testRemoveAllSessions() {
        let subject = service.saveSubject(name: "CS")
        _ = service.saveSession(seconds: 60, subject: subject!)

        service.removeAllSessions()
        XCTAssertEqual(service.fetchAllSessions().count, 0)
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Subject")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
    func initStubs() {
        func saveSubject( name: String) -> Subject? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: mockPersistantContainer.viewContext)
            obj.setValue(name, forKey: "name")
            return obj as? Subject
        }
        
        _ = saveSubject(name: "English")
        _ = saveSubject(name: "Maths")
        _ = saveSubject(name: "Science")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "pomodoro", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()

}
