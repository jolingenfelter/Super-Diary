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
    let entryTextView = UITextView()
    let entryAddLocationButton = UIButton()
    let entryLocationLabel = UILabel()
    let entryAddImageButton = UIButton()
    let entryDeleteImageButton = UIButton()
    let entryImageView = UIImageView()
    let entrySpectacularButton = UIButton()
    let entryFineButton = UIButton()
    let entrySubstandardButton = UIButton()
    
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
    
    // Location
    var locationManager: LocationManager!
    var location: CLLocation?
    
    lazy var entryViewModel: EntryDetailViewModel = {
        let viewModel = EntryDetailViewModel(entry: self.entry)
        viewModel.delegate = self
        return viewModel
    }()
    
    init(entry: Entry?) {
        self.entry = entry
        if let entry = entry {
            selectedRating = Rating(rawValue: entry.rating!)!
            imageData = entry.image
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarSetup()
        setupRatingButtons()
        buttonSetup()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        entryViewModel.configureView(self)
        self.title = entryViewModel.dateString
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: NSNotification.Name(rawValue: "LocationSet"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LocationSet"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        // TextView
        
        view.addSubview(entryTextView)
        entryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            entryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            entryTextView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: 20),
            entryTextView.heightAnchor.constraint(equalToConstant: 200)])
        
        // AddLocationButton
        
        view.addSubview(entryAddLocationButton)
        entryAddLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryAddLocationButton.topAnchor.constraint(equalTo: entryTextView.bottomAnchor, constant: 10),
            entryAddLocationButton.leadingAnchor.constraint(equalTo: entryTextView.leadingAnchor),
            entryAddLocationButton.heightAnchor.constraint(equalToConstant: 35),
            entryAddLocationButton.widthAnchor.constraint(equalToConstant: 150)])
        
        // LocationLabel
        
        view.addSubview(entryLocationLabel)
        entryLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryLocationLabel.leadingAnchor.constraint(equalTo: entryAddLocationButton.leadingAnchor),
            entryLocationLabel.topAnchor.constraint(equalTo: entryAddLocationButton.bottomAnchor, constant: 5),
            entryLocationLabel.heightAnchor.constraint(equalToConstant: 20),
            entryLocationLabel.widthAnchor.constraint(equalToConstant: 200)])
        
        // ActivityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: entryAddLocationButton.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: entryLocationLabel.topAnchor)
            ])
        
        // ImageView
        
        view.addSubview(entryImageView)
        entryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            entryImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            entryImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            entryImageView.heightAnchor.constraint(equalToConstant: 200)])
        
        // AddImageButton
        
        view.addSubview(entryAddImageButton)
        entryAddImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryAddImageButton.bottomAnchor.constraint(equalTo: entryImageView.topAnchor, constant: -5),
            entryAddImageButton.leadingAnchor.constraint(equalTo: entryImageView.leadingAnchor),
            ])
        
        // DeleteImageButton
        view.addSubview(entryDeleteImageButton)
        entryDeleteImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entryDeleteImageButton.topAnchor.constraint(equalTo: entryAddImageButton.topAnchor),
            entryDeleteImageButton.trailingAnchor.constraint(equalTo: entryImageView.trailingAnchor)
            ])
        
        // RatingButtonBar
        
        let buttonsArray = [entrySubstandardButton, entryFineButton, entrySpectacularButton]
        
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
    
    func buttonSetup() {
        entryAddLocationButton.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        entryAddImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        entryDeleteImageButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }
    
    // Add Location
    
    @objc func addLocation() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        locationManager = LocationManager()
        locationManager.onLocationFix = { [weak self] placeMark, error in
            
            guard let strongSelf = self else {
                return
            }
        
            if let placeMark = placeMark {
                strongSelf.location = placeMark.location
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.isHidden = true
                strongSelf.entryLocationLabel.isHidden = false
                
                guard let name = placeMark.name, let city = placeMark.locality, let area = placeMark.administrativeArea else {
                    return
                }
                
                strongSelf.entryLocationLabel.text = "\(name), \(city), \(area)"
                strongSelf.entryLocationLabel.textColor = .lightGray
                strongSelf.entryAddLocationButton.setTitle("Location", for: .normal)
                strongSelf.entryAddLocationButton.isEnabled = false
            }
            
        }
        
    }
    
    @objc func updateLocation() {
        self.locationLabel.text = entryViewModel.locationString
    }
    
    // AddImage
    
    @objc func addImage() {
        
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
    
    @objc func deleteImage() {
        
        let alert = UIAlertController(title: "Are you sure you want to delete this image?", message: "This action cannot be undone", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            self.entry?.image = nil
            self.imageData = nil
            self.entryImageView.image = UIImage(named: "icn_noImage")
            self.entryImageView.layer.borderColor = UIColor.lightGray.cgColor
            self.coreDataStack.saveContext()
            self.entryDeleteImageButton.isHidden = true
            
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
    
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func savePressed() {
        
        if entryTextView.text == "" || selectedRating == nil {
            
            self.presentAlert(withTitle: "Oops!", andMessage: "Entries require some text and a mood")
            
        } else {
            
            if let entry = self.entry {
                
                entry.note = entryTextView.text
                entry.rating = selectedRating?.rawValue
                entry.image = imageData
                
                if let location = location {
                    
                    let locationToSave = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    entry.location = locationToSave
                    
                }
                
                coreDataStack.saveContext()
                
            } else {
                entry = Entry.entry(withNote: entryTextView.text, image: self.imageData, rating: selectedRating?.rawValue, and: location)
                coreDataStack.saveContext()
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

// MARK: - SetRating

extension EntryDetailViewController {
    
    func setupRatingButtons() {
        
        entrySpectacularButton.setImage(UIImage(named: "icn_good_lrg"), for: .normal)
        entrySpectacularButton.imageView?.contentMode = .center
        entrySpectacularButton.backgroundColor = UIColor(red: 125/255, green: 156/255, blue: 91/255, alpha: 1)
        entrySpectacularButton.addTarget(self, action: #selector(superSelected), for: .touchUpInside)
        
        entryFineButton.setImage(UIImage(named: "icn_average_lrg"), for: .normal)
        entryFineButton.imageView?.contentMode = .center
        entryFineButton.backgroundColor = UIColor(red: 247/255, green: 167/255, blue: 0, alpha: 1)
        entryFineButton.addTarget(self, action: #selector(fineSelected), for: .touchUpInside)
        
        entrySubstandardButton.setImage(UIImage(named: "icn_bad_lrg"), for: .normal)
        entrySubstandardButton.imageView?.contentMode = .center
        entrySubstandardButton.backgroundColor = UIColor(red: 226/255, green: 95/255, blue: 93/255, alpha: 1)
        entrySubstandardButton.addTarget(self, action: #selector(substandardSelected), for: .touchUpInside)

        
    }
    
    func setRating(rating: Rating) {
        
        self.entrySpectacularButton.alpha = 0.5
        self.entryFineButton.alpha = 0.5
        self.entrySubstandardButton.alpha = 0.5
        
        switch rating {
            
        case .spectacular:
            
            selectedRating = Rating.spectacular
            entrySpectacularButton.alpha = 1.0
        
        case .fine:
            
            selectedRating = Rating.fine
            entryFineButton.alpha = 1.0
        
        case .substandard:
            
            selectedRating = Rating.substandard
            entrySubstandardButton.alpha = 1.0
            
        }
        
    }
    
    @objc func superSelected() {
        setRating(rating: Rating.spectacular)
    }
    
    @objc func fineSelected() {
        setRating(rating: Rating.fine)
    }
    
    @objc func substandardSelected() {
        setRating(rating: Rating.substandard)
    }
    
}

// MARK: - MediaPickerManagerDelegate

extension EntryDetailViewController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        manager.dismissImagePickerController(animated: true) {
            self.entryImageView.contentMode = .scaleAspectFill
            self.entryAddImageButton.setTitle("Edit Image", for: .normal)
            self.entryImageView.clipsToBounds = true
            self.entryImageView.image = image
            self.imageData = UIImageJPEGRepresentation(image, 1.0)
            self.entryDeleteImageButton.isHidden = false
        }
    }
    
}

// MARK: - ViewModelDelegate

extension EntryDetailViewController: EntryDetailViewModelDelegate {
    func didSet(locationString: String?) {
        self.locationLabel.text = locationString
    }
}

// MARK: - Gestures

extension EntryDetailViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - EntryDetailModelView

extension EntryDetailViewController: EntryDetailModelView {
    
    var noteTextView: UITextView {
        return entryTextView
    }
    
    var addLocationButton: UIButton {
        return entryAddLocationButton
    }
    
    var locationLabel: UILabel {
        return entryLocationLabel
    }
    
    var addImageButton: UIButton {
        return entryAddImageButton
    }
    
    var deleteImageButton: UIButton {
        return entryDeleteImageButton
    }
    
    var imageView: UIImageView {
        return entryImageView
    }
    
    var spectacularButton: UIButton {
        return entrySpectacularButton
    }
    
    var fineButton: UIButton {
        return entryFineButton
    }
    
    var substandardButton: UIButton {
        return entrySubstandardButton
    }
    
}
