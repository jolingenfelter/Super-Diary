//
//  EntryDetailViewController.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 3/1/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreLocation

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
        textView.font = .systemFont(ofSize: 16)
       
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.isHidden = true
        return view
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
    
    lazy var deleteImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        
        return button

    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()
    
    // Rating Buttons
    let spectacularButton = UIButton()
    let fineButton = UIButton()
    let substandardButton = UIButton()
    
    // Location
    var locationManager: LocationManager!
    var location: CLLocation?
    
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
        
        if let date = entry?.date {
            self.title = dateFormatter.string(from: date)
        } else {
            self.title = dateFormatter.string(from: Date())
        }
        
        if let data = entry?.image {
            imageData = entry?.image
            let image = UIImage(data: data as Data)
            imageView.image = image
            addImageButton.setTitle("Edit Image", for: .normal)
            imageView.layer.borderWidth = 0
            deleteImageButton.isHidden = false
        } else {
            deleteImageButton.isHidden = true
            imageView.contentMode = .center
            imageView.image = UIImage(named: "icn_noimage")
        }
        
        if let rating = entry?.rating {
            let savedRating = Rating(rawValue: rating)
            setRating(rating: savedRating!)
        } else {
            self.spectacularButton.alpha = 0.5
            self.fineButton.alpha = 0.5
            self.substandardButton.alpha = 0.5
        }
        
        if let location = entry?.location {
            
            addLocationButton.setTitle("Location", for: .normal)
            addLocationButton.isEnabled = false
            
            locationManager = LocationManager()
            
            let latitude = location.latitude
            let longitude = location.longitude
            
            let locationPoint = CLLocation(latitude: latitude, longitude: longitude)
            self.location = locationPoint
            
            locationManager.getPlacemark(forLocation: locationPoint) { placemark, error in
                
                if let error = error {
                    print(error)
                } else if let placemark = placemark {
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }

                
            }
            
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
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
        
        // ActivityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: addLocationButton.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: locationLabel.topAnchor)
            ])
        
        // ImageView
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            imageView.heightAnchor.constraint(equalToConstant: 200)])
        
        // AddImageButton
        
        view.addSubview(addImageButton)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addImageButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            addImageButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            ])
        
        // DeleteImageButton
        view.addSubview(deleteImageButton)
        deleteImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteImageButton.topAnchor.constraint(equalTo: addImageButton.topAnchor),
            deleteImageButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
            ])
        
        // RatingButtonBar
        
        let buttonsArray = [substandardButton, fineButton, spectacularButton]
        
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
    
    // Add Location
    
    func addLocation() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        locationManager = LocationManager()
        locationManager.onLocationFix = { placeMark, error in
        
            if let placeMark = placeMark {
                self.location = placeMark.location
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.locationLabel.isHidden = false
                
                guard let name = placeMark.name, let city = placeMark.locality, let area = placeMark.administrativeArea else {
                    return
                }
                
                self.locationLabel.text = "\(name), \(city), \(area)"
                self.addLocationButton.setTitle("Location", for: .normal)
                self.addLocationButton.isEnabled = false
            }
            
        }
        
    }
    
    // AddImage
    
    func addImage() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.mediaPickerManager.presentImagePickerController(animated: true, andSourceType: .camera)
        }
        actionSheet.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.mediaPickerManager.presentImagePickerController(animated: true, andSourceType: .photoLibrary)
        }
        actionSheet.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    // DeleteImage
    
    func deleteImage() {
        
        let alert = UIAlertController(title: "Are you sure you want to delete this image?", message: "This action cannot be undone", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            self.entry?.image = nil
            self.imageData = nil
            self.imageView.image = UIImage(named: "icn_noImage")
            self.imageView.layer.borderColor = UIColor.lightGray.cgColor
            self.coreDataStack.saveContext()
            self.deleteImageButton.isHidden = true
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
        
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
        
        if noteTextView.text == "" || selectedRating == nil {
            
            self.presentAlert(withTitle: "Oops!", andMessage: "Entries require some text and a mood")
            
        } else {
            
            if let entry = self.entry {
                
                entry.note = noteTextView.text
                entry.rating = selectedRating?.rawValue
                entry.image = imageData
                
                if let location = location {
                    
                    let locationToSave = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    entry.location = locationToSave
                    
                }
                
                coreDataStack.saveContext()
                
            } else {
                entry = Entry.entry(withNote: noteTextView.text, image: self.imageData, rating: selectedRating?.rawValue, and: location)
                coreDataStack.saveContext()
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

// MARK: - SetRating

extension EntryDetailViewController {
    
    func setupRatingButtons() {
        
        spectacularButton.setImage(UIImage(named: "icn_good_lrg"), for: .normal)
        spectacularButton.imageView?.contentMode = .center
        spectacularButton.backgroundColor = UIColor(colorLiteralRed: 125/255, green: 156/255, blue: 91/255, alpha: 1)
        spectacularButton.addTarget(self, action: #selector(superSelected), for: .touchUpInside)
        
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
        
        self.spectacularButton.alpha = 0.5
        self.fineButton.alpha = 0.5
        self.substandardButton.alpha = 0.5
        
        switch rating {
            
        case .spectacular:
            
            selectedRating = Rating.spectacular
            spectacularButton.alpha = 1.0
        
        case .fine:
            
            selectedRating = Rating.fine
            fineButton.alpha = 1.0
        
        case .substandard:
            
            selectedRating = Rating.substandard
            substandardButton.alpha = 1.0
            
        }
        
    }
    
    func superSelected() {
        setRating(rating: Rating.spectacular)
    }
    
    func fineSelected() {
        setRating(rating: Rating.fine)
    }
    
    func substandardSelected() {
        setRating(rating: Rating.substandard)
    }
    
}

// MARK: - MediaPickerManagerDelegate

extension EntryDetailViewController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        manager.dismissImagePickerController(animated: true) {
            self.imageView.contentMode = .scaleAspectFit
            self.addImageButton.setTitle("Edit Image", for: .normal)
            self.imageView.clipsToBounds = true
            self.imageView.image = image
            self.imageView.layer.borderWidth = 0.0
            self.imageData = UIImageJPEGRepresentation(image, 1.0)
            self.deleteImageButton.isHidden = false
        }
    }
    
}

// MARK: - Gestures

extension EntryDetailViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
