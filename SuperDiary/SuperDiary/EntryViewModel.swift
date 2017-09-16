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

public final class EntryDetailViewModel {
    
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
                }
            })
            
        }
        
        if let image = entry.userImage {
            self.image = image
        }
    }
}

extension EntryDetailViewModel {
    
    func configureView(_ view: EntryDetailModelView) {
        
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
        }
        
    }
    
}
