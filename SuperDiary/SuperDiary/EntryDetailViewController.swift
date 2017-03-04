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
    var selectedRating: Rating?
    var imageData: Data?
    
    // Views
    
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
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add image", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()
    
    // Rating Buttons
    let superButton = UIButton()
    let fineButton = UIButton()
    let substandardButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarSetup()
        setupRatingButtons()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        
        configureView(withEntry: entry)
    }
    
    fileprivate func configureView(withEntry entry: Entry?) {
        
        noteTextView.text = entry?.note
        
        if let image = entry?.userImage {
            self.imageView.image = image
            addImageButton.setTitle("Edit Image", for: .normal)
        } else {
            imageView.contentMode = .center
            imageView.image = UIImage(named: "icn_noimage")
        }
        
        if let rating = entry?.rating {
            let savedRating = Rating(rawValue: rating)
            setRating(rating: savedRating!)
        } else {
            self.superButton.alpha = 0.5
            self.fineButton.alpha = 0.5
            self.substandardButton.alpha = 0.5
        }
        
        // TODO: - Location
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        // TextView
        
        view.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: 20),
            noteTextView.heightAnchor.constraint(equalToConstant: 200)])
        
        // AddLocationButton
        
        view.addSubview(addLocationButton)
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addLocationButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 10),
            addLocationButton.leadingAnchor.constraint(equalTo: noteTextView.leadingAnchor),
            addLocationButton.heightAnchor.constraint(equalToConstant: 35),
            addLocationButton.widthAnchor.constraint(equalToConstant: 150)])
        
        // LocationLabel
        
        view.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: addLocationButton.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: addLocationButton.bottomAnchor, constant: 5),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            locationLabel.widthAnchor.constraint(equalToConstant: 200)])
        
        // ImageView
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            imageView.heightAnchor.constraint(equalToConstant: 200)])
        
        // AddImageButton
        
        view.addSubview(addImageButton)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addImageButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            addImageButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            ])
        
        // RatingButtonBar
        
        let buttonsArray = [substandardButton, fineButton, superButton]
        
        let ratingButtonBar = UIStackView(arrangedSubviews: buttonsArray)
        ratingButtonBar.axis = .horizontal
        ratingButtonBar.spacing = 0
        ratingButtonBar.distribution = .fillEqually
        ratingButtonBar.alignment = .fill
        
        view.addSubview(ratingButtonBar)
        ratingButtonBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingButtonBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ratingButtonBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ratingButtonBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ratingButtonBar.heightAnchor.constraint(equalToConstant: 40)])
        
    }
    
    // MARK: - Buttons
    
    func addLocation() {
        
    }
    
    func addImage() {
        mediaPickerManager.presentImagePickerController(animated: true)
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
        
        if let entry = self.entry {
            
            entry.note = noteTextView.text
            entry.rating = selectedRating?.rawValue
            
            coreDataStack.saveContext()
            
        } else {
            Entry.entry(withNote: noteTextView.text, image: self.imageData, rating: selectedRating?.rawValue, and: nil)
            coreDataStack.saveContext()
        }
        
    }
    
}

// MARK: - SetRating

extension EntryDetailViewController {
    
    func setupRatingButtons() {
        
        superButton.setImage(UIImage(named: "icn_good_lrg"), for: .normal)
        superButton.imageView?.contentMode = .center
        superButton.backgroundColor = UIColor(colorLiteralRed: 125/255, green: 156/255, blue: 91/255, alpha: 1)
        superButton.addTarget(self, action: #selector(superSelected), for: .touchUpInside)
        
        fineButton.setImage(UIImage(named: "icn_average_lrg"), for: .normal)
        fineButton.imageView?.contentMode = .center
        fineButton.backgroundColor = UIColor(colorLiteralRed: 247/255, green: 167/255, blue: 0, alpha: 1)
        fineButton.addTarget(self, action: #selector(fineSelected), for: .touchUpInside)
        
        substandardButton.setImage(UIImage(named: "icn_bad_lrg"), for: .normal)
        substandardButton.imageView?.contentMode = .center
        substandardButton.backgroundColor = UIColor(colorLiteralRed: 226/255, green: 95/255, blue: 93/255, alpha: 1)
        substandardButton.addTarget(self, action: #selector(substandardSelected), for: .touchUpInside)

        
    }
    
    func setRating(rating: Rating) {
        
        self.superButton.alpha = 0.5
        self.fineButton.alpha = 0.5
        self.substandardButton.alpha = 0.5
        
        switch rating {
            
        case .Super:
            
            selectedRating = Rating.Super
            superButton.alpha = 1.0
            
            break
        
        case .Fine:
            
            selectedRating = Rating.Fine
            fineButton.alpha = 1.0
            
            break
        
        case .Substandard:
            
            selectedRating = Rating.Substandard
            substandardButton.alpha = 1.0
            
            break
            
        }
        
    }
    
    func superSelected() {
        setRating(rating: Rating.Super)
    }
    
    func fineSelected() {
        setRating(rating: Rating.Fine)
    }
    
    func substandardSelected() {
        setRating(rating: Rating.Substandard)
    }
    
}

// MARK: - MediaPickerManagerDelegate

extension EntryDetailViewController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        manager.dismissImagePickerController(animated: true) {
            self.imageView.image = image
            print(self.imageView.frame.size)
            print(image.size)
            self.imageData = UIImageJPEGRepresentation(image, 1.0)
        }
    }
    
}

// MARK: - Gestures

extension EntryDetailViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
