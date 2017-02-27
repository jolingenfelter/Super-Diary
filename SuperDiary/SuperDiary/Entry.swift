//
//  Entry.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 2/27/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData

class Entry: NSManagedObject {
    
    static let entityName = "\(Entry.self)"
    
    static var allEntiesRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entry.entityName)
        request.sortDescriptors = [NSSortDescriptor(key:"date", ascending: true)]
        return request
    }()
    
}
