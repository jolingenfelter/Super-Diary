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
        return EntryDataSource(fetchRequest: Entry.allEntriesRequest, tableView: self.tableView)
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        navigationBarSetup()
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
        
    }
}
