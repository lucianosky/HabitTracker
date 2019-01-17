//
//  Date+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 17/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation

extension Date {
    
    var yyyymmdd: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: self)
        }
    }
    
}
