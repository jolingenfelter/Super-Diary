//
//  EntryDetailViewController.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 3/1/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    let coreDataStack = CoreDataStack.sharedInstance
    var entry: Entry?
    
    // View Variables
    
    lazy var noteTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navbarSetup()
        
        // Show data of pre-existing note
        noteTextView.text = entry?.note
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Navigation

extension EntryDetailViewController {
    
    func navbarSetup() {
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed))
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
    }
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePressed() {
        
    }
    
}
