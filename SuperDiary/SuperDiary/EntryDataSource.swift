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
    
    let tableView: UITableView
    private let managedObjectContext = CoreDataStack.sharedInstance.managedObjectContext
    let fetchedResultsController: EntryFetchedResultsController
    var entries: [Entry]?
    let searchController: UISearchController
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, tableView: UITableView, searchController: UISearchController) {
        
        self.tableView = tableView
        self.fetchedResultsController = EntryFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, tableView: self.tableView)
        entries = []
        self.searchController = searchController
        
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
//        return fetchedResultsController.fetchedObjects?.count ?? 0
        
        if searchController.isActive {
            return entries?.count ?? 0
        } else {
            return fetchedResultsController.fetchedObjects?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as! EntryCell
        
        if searchController.isActive {
            
            if let entries = entries {
                let entry = entries[indexPath.row]
                cell.configureCell(forEntry: entry)
            }
            
        } else {
            
            let entry = self.fetchedResultsController.object(at: indexPath) as! Entry
            cell.configureCell(forEntry: entry)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if searchController.isActive == true {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let entry = self.fetchedResultsController.object(at: indexPath) as! Entry
        
        if editingStyle == .delete {
            CoreDataStack.sharedInstance.managedObjectContext.delete(entry)
            CoreDataStack.sharedInstance.saveContext()
        }
        
    }
    
}

// MARK: - UISearchResultsUpdating

extension EntryDataSource: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            let retrievedEntries = Entry.searchEntry(withText: searchText)
            self.entries = retrievedEntries
        }
        self.tableView.reloadData()
    }
        
}
    

