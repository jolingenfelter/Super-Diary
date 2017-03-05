//
//  RoundImageView.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 3/2/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func roundImage() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
}
