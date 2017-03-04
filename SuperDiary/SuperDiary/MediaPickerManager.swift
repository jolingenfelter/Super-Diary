//
//  MediaPickerManager.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 3/4/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol MediaPickerManagerDelegate: class {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

class MediaPickerManager: NSObject {
    
    private let imagePickerController = UIImagePickerController()
    private let presentingViewController: UIViewController
    
    weak var delegate: MediaPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    func presentImagePickerController(animated: Bool) {
        presentingViewController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool, completion: @escaping (() -> Void)) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
}

extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.mediaPickerManager(manager: self, didFinishPickingImage: image)
    }
    
}
