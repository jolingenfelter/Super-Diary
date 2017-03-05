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
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
    }
    
    func presentImagePickerController(animated: Bool, andSourceType sourceType: UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            if sourceType == .camera {
                imagePickerController.sourceType = .camera
                imagePickerController.cameraDevice = .rear
                
            }else {
                imagePickerController.sourceType = .photoLibrary
            }
        }
        
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
