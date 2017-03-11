//
//  SuperDiaryTests.swift
//  SuperDiaryTests
//
//  Created by Joanna Lingenfelter on 3/6/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
@testable import SuperDiary

class SuperDiaryTests: XCTestCase {
    
    var tableView = UITableView()
    var searchController = UISearchController()
    
    let coreDataStack = CoreDataStack.sharedInstance
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let model = NSManagedObjectModel.mergedModel(from: nil)
        return model!
        
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            
            try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            
        } catch let error {
            print("Unresolved error: \(error)")
        }
        
        return storeCoordinator
        
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
        
    }()
    
    lazy var fetchedResultsController: EntryFetchedResultsController = {
        
        let fetchedResultsController = EntryFetchedResultsController(fetchRequest: Entry.allEntriesRequest, managedObjectContext: self.managedObjectContext, tableView: self.tableView)
        return fetchedResultsController
        
    }()
    

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        coreDataStack.managedObjectContext = self.managedObjectContext
        
    }
    
    func createFakeEntry() {
        
        let fakeEntry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: coreDataStack.managedObjectContext) as! Entry
        fakeEntry.note = "Test Note"
        fakeEntry.date = Date()
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: coreDataStack.managedObjectContext) as? Location
        location?.latitude = 0.0
        location?.longitude = 0.0
        fakeEntry.location = location
        fakeEntry.image = UIImageJPEGRepresentation(UIImage(named: "icn_happy")!, 1.0)
        
        coreDataStack.saveContext()
    }
    
    func deleteFakeEntry() {
        
        if let entry = self.fetchedResultsController.fetchedObjects?.first {
            
            coreDataStack.managedObjectContext.delete(entry as! NSManagedObject)
            coreDataStack.saveContext()
            
        }
        
    }
    
    func testCreateFakeEntry() {
        
        XCTAssert(self.fetchedResultsController.fetchedObjects?.count == 0, "There is already a note")
        
        createFakeEntry()
        
        XCTAssert(self.fetchedResultsController.fetchedObjects?.count == 1, "No entry was created successfully")
        
        deleteFakeEntry()
    }
    
    func testDeleteFakeNote() {
        
        createFakeEntry()
        
        XCTAssert(self.fetchedResultsController.fetchedObjects?.count == 1, "Note was NOT created successfully")
        
        deleteFakeEntry()
        
        XCTAssert(self.fetchedResultsController.fetchedObjects?.count == 0, "Note was Not deleted")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        deleteFakeEntry()
        
        super.tearDown()
    }
}
    
    

