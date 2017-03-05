//
//  EntryDataSource.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 2/28/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntryDataSource: NSObject {
    
    private let tableView: UITableView
    private let managedObjectContext = CoreDataStack.sharedInstance.managedObjectContext
    let fetchedResultsController: EntryFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, tableView: UITableView) {
        
        self.tableView = tableView
        self.fetchedResultsController = EntryFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, tableView: self.tableView)
        
        super.init()
        
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        self.fetchedResultsController.performFetch(withPredicate: predicate)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension EntryDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as! EntryCell
        let entry = self.fetchedResultsController.object(at: indexPath) as! Entry
        
        cell.entryDateLabel.text = dateFormatter.string(from: entry.date)
        cell.entryTextLabel.text = entry.note
        
        if entry.userImage != nil {
            cell.entryImageView.image = entry.userImage
        } else {
            cell.entryImageView.image = UIImage(named: "icn_noimage")
        }
        
        if let entryRating = entry.rating {
            
            cell.ratingImageView.isHidden = false
            let rating = Rating(rawValue: entryRating)!
            
            switch rating {
            
            case .Super:
                
                cell.ratingImageView.image = UIImage(named: "icn_happy")
                
            case .Fine:
                
                cell.ratingImageView.image = UIImage(named: "icn_average")
                
            case .Substandard:
                
                cell.ratingImageView.image = UIImage(named: "icn_bad")
            }
            
        } else {
            cell.ratingImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let entry = self.fetchedResultsController.object(at: indexPath) as! Entry
        
        if editingStyle == .delete {
            CoreDataStack.sharedInstance.managedObjectContext.delete(entry)
            CoreDataStack.sharedInstance.saveContext()
        }
        
    }
    
}
