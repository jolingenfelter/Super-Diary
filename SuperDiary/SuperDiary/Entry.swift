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
    
    class func entry(withNote note: String?, Image image: UIImage?, andRating rating: String?) -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: CoreDataStack.sharedInstance.managedObjectContext) as! Entry
        
        entry.date = Date().timeIntervalSince1970
        
        entry.note = note
        
        if let image = image {
            entry.image = UIImageJPEGRepresentation(image, 1.0)
        }
        
        entry.rating = rating
        
        return entry
    }
    
    class func entry(withNote note: String?, image: UIImage?, rating: String?, and location: CLLocation) {
        
        let entry = Entry.entry(withNote: note, Image: image, andRating: rating)
        entry.addLocation(location: location)
        
    }
    
    func addLocation(location: CLLocation?) {
        if let location = location {
            let entryLocation = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = entryLocation
        }
    }
    
}

extension Entry {
    
    @NSManaged var date: TimeInterval
    @NSManaged var note: String?
    @NSManaged var image: Data?
    @NSManaged var location: Location?
    @NSManaged var rating: String?
    
    var userImage: UIImage? {
        
        guard let image = image else {
            return nil
        }
        
        return UIImage(data: image)
    }
}
