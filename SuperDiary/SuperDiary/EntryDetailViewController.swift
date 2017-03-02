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
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.5
       
        return textView
    }()
    
    lazy var addLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add location", for: .normal)
        button.setTitleColor(.lightGray , for: .normal)
        let geolocateImage = UIImage(named: "icn_geolocate")
        button.setImage(geolocateImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navbarSetup()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        // Show data of pre-existing note
        noteTextView.text = entry?.note
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        view.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: 20),
            noteTextView.heightAnchor.constraint(equalToConstant: 200)])
        
        view.addSubview(addLocationButton)
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addLocationButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 15),
            addLocationButton.leadingAnchor.constraint(equalTo: noteTextView.leadingAnchor),
            addLocationButton.heightAnchor.constraint(equalToConstant: 35),
            addLocationButton.widthAnchor.constraint(equalToConstant: 150)])
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    // MARK: - Location
    
    func addLocation() {
        
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
