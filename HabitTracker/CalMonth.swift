//
//  CalMonth.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 05/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation

struct CalMonth {
    
    let firstMonthDate: Date
    let lastMonthDate: Date
    let firstCalDate: Date
    let lastCalDate: Date
    let weeks: Int

    init() {
        var components = Calendar.current.dateComponents([.year, .month], from: Date())
        // TODO optionals
        self.init(year: components.year!, month: components.month!)
    }
    
    init (date: Date) {
        var components = Calendar.current.dateComponents([.year, .month], from: date)
        // TODO optionals
        self.init(year: components.year!, month: components.month!)
    }
    
    init(year: Int, month: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        firstMonthDate = Calendar.current.date(from: components)!
        lastMonthDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: firstMonthDate)!
        
        let firstWeekday = Calendar.current.component(.weekday, from: firstMonthDate)
        let lastWeekday = Calendar.current.component(.weekday, from: lastMonthDate)
        // TODO: this works for weeks starting MONDAY
        let deltaBefore = firstWeekday == 1 ? -6 : -firstWeekday + 2
        let deltaAfter = lastWeekday == 1 ? 0 : 8 - lastWeekday
        
        firstCalDate = Calendar.current.date(byAdding: DateComponents(day: deltaBefore), to: firstMonthDate)!
        lastCalDate = Calendar.current.date(byAdding: DateComponents(day: deltaAfter), to: lastMonthDate)!
        
        let days = Calendar.current.dateComponents([.day], from: firstCalDate, to: lastCalDate).day! + 1
        weeks = days / 7
    }
    
    
    func getWeekDays(_ week: Int) -> [CalDay] {
        // TODO: optionals
        var date = Calendar.current.date(byAdding: DateComponents(day: week * 7), to: firstCalDate)!
        var calDays:[CalDay] = []
        for _ in 0...6 {
            let day = Calendar.current.dateComponents([.day], from: date).day ?? 0
            let fromMonth = date >= firstMonthDate && date <= lastMonthDate
            let calDay = CalDay(day: day, fromMonth: fromMonth)
            calDays.append(calDay)
            date = Calendar.current.date(byAdding: DateComponents(day: 1), to: date)!
        }
        return calDays
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: firstMonthDate)
    }
    
    func year() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: firstMonthDate)
    }
    
    func addComponent(component: Calendar.Component, value: Int) -> Date {
        // TODO optional
        return Calendar.current.date(byAdding: component, value: value, to: firstMonthDate)!
    }
    
    static func getWeekHeaders() -> [String] {
        // TODO: this works for weeks starting MONDAY
        return [ "M", "T", "W", "T", "F", "S", "S" ]
        //return Calendar.current.veryShortWeekdaySymbols
    }
    
}

struct CalDay {
    let day: Int
    let fromMonth: Bool
}
