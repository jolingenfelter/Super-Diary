//
//  Location.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 2/27/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {
    
    static let entityName = "\(Location.self)"
    
    class func location(withLatitude latitude: Double, longitude: Double) -> Location {
        
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: CoreDataStack.sharedInstance.managedObjectContext) as! Location
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    }
    
}

extension Location {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}
