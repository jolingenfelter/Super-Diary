//
//  EntryViewModel.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 9/16/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreLocation

@objc public protocol EntryDetailModelView {
    @objc optional var noteTextView: UITextView { get }
    @objc optional var addLocationButton: UIButton { get }
    @objc optional var locationLabel: UILabel { get }
    @objc optional var addImageButton: UIButton { get }
    @objc optional var deleteImageButton: UIButton { get }
    @objc optional var imageView: UIImageView { get }
    @objc optional var spectacularButton: UIButton { get }
    @objc optional var fineButton: UIButton { get }
    @objc optional var substandardButton: UIButton { get }
}

protocol EntryDetailViewModelDelegate {
    func didSet(locationString: String?)
}

public final class EntryDetailViewModel {
    
    var delegate: EntryDetailViewModelDelegate!
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter
    }()
    
    var entry: Entry?
    var locationManager: LocationManager!
    var location: CLLocation?
    var locationString: String? 
    var rating: Rating?
    var dateString: String?
    var image: UIImage?
    
    init(entry: Entry?) {
        self.entry = entry
        self.locationManager = LocationManager()
        
        guard let entry = entry else {
            self.dateString = dateFormatter.string(from: Date())
            return
        }
        
        self.dateString = dateFormatter.string(from: entry.date)
        
        if let rating = entry.rating {
            self.rating = Rating(rawValue: rating)
        }
        
        if let location = entry.location {

            let latitude = location.latitude
            let longitude = location.longitude

            let locationPoint = CLLocation(latitude: latitude, longitude: longitude)
            self.location = locationPoint

            locationManager.getPlacemark(forLocation: locationPoint, completionHandler: { (placemark, error) in
                if let placemark = placemark {
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                self.locationString  = "\(name), \(city), \(area)"
                self.delegate.didSet(locationString: self.locationString)
                }
            })
        }
        
        if let image = entry.userImage {
            self.image = image
        }
    }
}

extension EntryDetailViewModel {
    
    // MARK: - Configure View
    
    func configureView(_ view: EntryDetailModelView) {
        
        textViewProperties(view)
        locationButtonProperties(view)
        addImageButtonProperties(view)
        deleteImageButtonProperties(view)
        imageViewProperties(view)
        
        if let entry = entry {
            view.noteTextView?.text = entry.note
        }
        
        if let rating = rating {
            
            view.spectacularButton?.alpha = 0.5
            view.fineButton?.alpha = 0.5
            view.substandardButton?.alpha = 0.5
            
            switch rating {
                
            case .spectacular:
                view.spectacularButton?.alpha = 1.0
            case .fine:
                view.fineButton?.alpha = 1.0
            case .substandard:
                view.substandardButton?.alpha = 1.0
            }

        } else {
            view.spectacularButton?.alpha = 0.5
            view.fineButton?.alpha = 0.5
            view.substandardButton?.alpha = 0.5
        }
        
        if let locationString = locationString {
            view.addLocationButton?.setTitle("Location", for: .normal)
            view.addLocationButton?.isEnabled = false
            view.locationLabel?.text = locationString
        }
        
        if let image = image {
            view.imageView?.image = image
            view.addImageButton?.setTitle("Edit", for: .normal)
        } else {
            view.deleteImageButton?.isHidden = true
        }
        
    }
    
    // MARK: - View Properties
    
    private func textViewProperties(_ view: EntryDetailModelView) {
        view.noteTextView?.layer.borderColor = UIColor.lightGray.cgColor
        view.noteTextView?.layer.borderWidth = 1.5
        view.noteTextView?.font = .systemFont(ofSize: 16)
    }
    
    private func locationButtonProperties(_ view: EntryDetailModelView) {
        view.addLocationButton?.setTitle("Add location", for: .normal)
        view.addLocationButton?.setTitleColor(.lightGray , for: .normal)
        let geolocateImage = UIImage(named: "icn_geolocate")
        view.addLocationButton?.setImage(geolocateImage, for: .normal)
        view.addLocationButton?.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        view.addLocationButton?.titleLabel?.textAlignment = .left
    }
    
    private func locationLabelProperties(_ view: EntryDetailModelView) {
        view.locationLabel?.textColor = UIColor.lightGray
        view.locationLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func addImageButtonProperties(_ view: EntryDetailModelView) {
        view.addImageButton?.setTitle("Add image", for: .normal)
        view.addImageButton?.setTitleColor(.lightGray, for: .normal)
        view.addImageButton?.titleLabel?.textAlignment = .left
    }
    
    private func deleteImageButtonProperties(_ view: EntryDetailModelView) {
        view.deleteImageButton?.setTitle("Delete", for: .normal)
        view.deleteImageButton?.setTitleColor(.lightGray, for: .normal)
        view.deleteImageButton?.titleLabel?.textAlignment = .left
    }
    
    private func imageViewProperties(_ view: EntryDetailModelView) {
        view.imageView?.contentMode = .scaleAspectFill
        view.imageView?.clipsToBounds = true
        view.imageView?.layer.masksToBounds = true
        view.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        view.imageView?.layer.borderWidth = 1.5
    }
    
}
