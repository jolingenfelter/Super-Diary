//
//  EntryListViewController.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 2/27/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class EntryListViewController: UIViewController {
    
    lazy var dataSource: EntryDataSource = {
        let fetchedResultsController = EntryFetchedResultsController(fetchRequest: Entry.allEntriesRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, tableView: self.tableView)
        return EntryDataSource(fetchRequest: Entry.allEntriesRequest, fetchedResultsController: fetchedResultsController, tableView: self.tableView, searchController: self.searchController)
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.reuseIdentifier)
        return tableView
    }()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        navigationBarSetup()
        searchBarSetup()
        self.title = "Super Diary"
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor), tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor), tableView.leftAnchor.constraint(equalTo: view.leftAnchor), tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   
}

// MARK: - UITableViewControllerDelegate

extension EntryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entry = dataSource.fetchedResultsController.object(at: indexPath) as! Entry
        let entryDetailViewController = EntryDetailViewController(entry: entry)
        let navigationController = UINavigationController(rootViewController: entryDetailViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}

// MARK: - Navigation

extension EntryListViewController {
    
    func navigationBarSetup() {
        let addEntryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newEntryPressed))
        navigationItem.rightBarButtonItem = addEntryButton
    }
    
    func newEntryPressed() {
        
        let entryDetailViewController = EntryDetailViewController(entry: nil)
        let navigationController = UINavigationController(rootViewController: entryDetailViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
}

// MARK: - SearchBar Setup

extension EntryListViewController {
    
    func searchBarSetup() {
        searchController.searchResultsUpdater = dataSource
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
}



























