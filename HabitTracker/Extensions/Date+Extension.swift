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
    
    static func fromComponents(year: Int, month: Int, day: Int = 1) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        // TODO optional
        return Calendar.current.date(from: components)!
    }
    
    func addDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
}
