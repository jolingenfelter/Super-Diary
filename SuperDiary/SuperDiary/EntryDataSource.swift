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
        
        print("data scource!")
        
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
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath)
        
        
        return cell
    }
    
}
