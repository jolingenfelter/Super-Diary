//
//  SuperDiaryCoreDataTests.swift
//  SuperDiaryCoreDataTests
//
//  Created by Joanna Lingenfelter on 3/11/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import XCTest
import CoreData
@testable import SuperDiary

class SuperDiaryCoreDataTests: XCTestCase {
    
    // MARK: - testCoreDataStack
    
    class testCoreDataStack {
        
        static let sharedInstance = testCoreDataStack()
        
        lazy var managedObjectModel: NSManagedObjectModel = {
            
            // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
            
            return NSManagedObjectModel.mergedModel(from: nil)!
            
        }()
        
        lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            
            // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
            // Create the coordinator and store
            
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            do {
                
                try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
                
            } catch let error {
                
                NSLog("Unresolved error \(error)")
                abort()
                
            }
            
            return coordinator
            
        }()
        
        
        lazy var managedObjectContext: NSManagedObjectContext = {
            
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            
            let coordinator = self.persistentStoreCoordinator
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
            
        }()
        
        // MARK: - CoreData saving support
        
        func saveContext() {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
        }
    }
    
    // MARK : - FetchedResultsController 
    
    let tableView = UITableView()
    lazy var fetchedResultsController: EntryFetchedResultsController = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entry.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"date", ascending: true)]
        let fetchedResultsController = EntryFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: testCoreDataStack.sharedInstance.managedObjectContext, tableView: self.tableView)
        return fetchedResultsController
    }()
    
    // MARK: - Create and Delete Entries
    
    func createFakeEntry() {
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: testCoreDataStack.sharedInstance.managedObjectContext) as! Entry
        
        entry.note = "Fake note"
        entry.date = Date()
        entry.image = UIImageJPEGRepresentation(UIImage(named: "icn_happy")!, 1.0)
        
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: testCoreDataStack.sharedInstance.managedObjectContext) as! Location
        location.latitude = 0.0
        location.longitude = 0.0
        
        entry.location = location
        
        testCoreDataStack.sharedInstance.saveContext()
        
    }
    
    func deleteEntry() {
        
        if let entry = fetchedResultsController.fetchedObjects?.first {
            testCoreDataStack.sharedInstance.managedObjectContext.delete(entry as! NSManagedObject)
            testCoreDataStack.sharedInstance.saveContext()
        }
        
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testCreateEntry() {
        
        fetchedResultsController.executeFetch()
        
        // Check that there are no entries
        XCTAssert(fetchedResultsController.fetchedObjects?.count == 0, "There is an existing note saved in Core Data")
        
        createFakeEntry()
        
        fetchedResultsController.executeFetch()
        
        // Check to see if entry was added
        XCTAssert(fetchedResultsController.fetchedObjects?.count == 1, "Entry was NOT saved")
        
        deleteEntry()
        
    }
    
    func testDeleteEntry() {
        
        // Add entry and check to make sure it is saved
        createFakeEntry()
        
        XCTAssert(fetchedResultsController.fetchedObjects?.count == 1, "There are no saved entries")
        
        // Delete entry and recheck to make sure it was deleted
        deleteEntry()
        
        XCTAssert(fetchedResultsController.fetchedObjects?.count == 0, "Note was not successfully deleted")
        
        
    }
    
    func testUpdateNote() {
        
        // Add entry and check to make sure it was added
        createFakeEntry()
        
        XCTAssert(fetchedResultsController.fetchedObjects?.count == 1, "There are no saved entries")
        
        let entry = fetchedResultsController.fetchedObjects?.first as! Entry
        entry.note = "Updated test entry"
        
        // Save updated note
        testCoreDataStack.sharedInstance.saveContext()
        
        // Check if note was updated
        XCTAssert(entry.note == "Updated test entry", "Entry was not successfully updated")
        
    }
    
}
