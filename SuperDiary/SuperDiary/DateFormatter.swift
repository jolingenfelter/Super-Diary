//
//  DateFormatter.swift
//  SuperDiary
//
//  Created by Joanna Lingenfelter on 3/2/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation


let dateFormatter: DateFormatter = {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    
    return dateFormatter
    
}()
