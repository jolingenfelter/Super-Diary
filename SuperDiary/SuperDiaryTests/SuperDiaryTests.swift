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
    
    var persistentStore: NSPersistentStore!
    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var entryDataSource: EntryDataSource!
    var tableView = UITableView()
    var searchController = UISearchController()
    var fetchedResultsController: EntryFetchedResultsController!
    
    let coreDataStack = CoreDataStack.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // CoreDataStack
        
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            
            try persistentStore = storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = storeCoordinator
            
        } catch let error {
            print("Unresolved error \(error)")
        }
        
        coreDataStack.managedObjectContext = managedObjectContext
        
        // DataSource
        
        entryDataSource = EntryDataSource(fetchRequest: Entry.allEntriesRequest, tableView: self.tableView, searchController: searchController)
        fetchedResultsController = entryDataSource.fetchedResultsController
        
        createFakeEntry()
        
    }
    
    func createFakeEntry() {
        
        let fakeEntry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: managedObjectContext) as! Entry
        fakeEntry.note = "Text Note"
        fakeEntry.date = NSDate() as Date
        fakeEntry.location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: managedObjectContext) as? Location
        fakeEntry.image = UIImageJPEGRepresentation(UIImage(named: "icn_happy")!, 1.0)
        
        coreDataStack.saveContext()
    }
    
    func deleteFakeEntry() {
        
        if let entry = self.fetchedResultsController.fetchedObjects?.first {
            
            coreDataStack.managedObjectContext.delete(entry as! NSManagedObject)
            coreDataStack.saveContext()
            
        }
        
    }
    
    func testDeleteFakeNote() {
        
        // Check note was created
        XCTAssert(self.fetchedResultsController.fetchedObjects?.count == 1, "Note was NOT created successfully")
        
        deleteFakeEntry()
        
        XCTAssert(self.fetchedResultsController.fetchedObjects?.count == 0, "Note was Not deleted")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        
        super.tearDown()
    }
    
    
}
