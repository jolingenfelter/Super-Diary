//
//  Entry.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 2/27/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class Entry: NSManagedObject {
    
    static let entityName = "\(Entry.self)"
    
    static var allEntriesRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entry.entityName)
        request.sortDescriptors = [NSSortDescriptor(key:"date", ascending: true)]
        return request
    }()
    
    class func entry(withNote note: String?, Image image: Data?, andRating rating: String?) -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: CoreDataStack.sharedInstance.managedObjectContext) as! Entry
        
        entry.date = Date()
        
        entry.note = note
        
        entry.image = image
        
        entry.rating = rating
        
        return entry
    }
    
    class func entry(withNote note: String?, image: Data?, rating: String?, and location: CLLocation?) -> Entry {
        
        let entry = Entry.entry(withNote: note, Image: image, andRating: rating)
        entry.addLocation(location: location)
        
        return entry
        
    }
    
    func addLocation(location: CLLocation?) {
        if let location = location {
            let entryLocation = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = entryLocation
        }
    }
    
    class func searchEntry(withText text: String) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.allEntriesRequest as! NSFetchRequest<Entry>
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: CoreDataStack.sharedInstance.managedObjectContext)
        
        let predicate = NSPredicate(format: "note CONTAINS[cd] %@", text)
        fetchRequest.predicate = predicate
        
        var retrievedEntries: [Entry] = []
        
        do {
            
            retrievedEntries = try CoreDataStack.sharedInstance.managedObjectContext.fetch(fetchRequest)
            
        } catch let error {
            print("Unresolved error: \(error)")
        }
        
        return retrievedEntries
    }
    
}

extension Entry {
    
    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var image: Data?
    @NSManaged public var location: Location?
    @NSManaged public var rating: String?
    
    var userImage: UIImage? {
        
        guard let image = image else {
            return nil
        }
        
        return UIImage(data: image)
    }
}
