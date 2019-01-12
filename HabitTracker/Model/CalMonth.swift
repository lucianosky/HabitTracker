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
    let startOfWeek: Int

    init (date: Date, startOfWeek: Int = 1) {
        var components = Calendar.current.dateComponents([.year, .month], from: date)
        // TODO optionals
        self.init(year: components.year!, month: components.month!, startOfWeek: startOfWeek)
    }
    
    init(year: Int, month: Int, startOfWeek: Int = 1) {
        
        func dayIndex(_ day: Int) -> Int {
            var index = day - (startOfWeek - 1)
            index = index > 0 ? index : index + 7
            return index
        }

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0

        self.startOfWeek = startOfWeek
        
        firstMonthDate = Calendar.current.date(from: components)!
        lastMonthDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: firstMonthDate)!

        let firstWeekday = Calendar.current.component(.weekday, from: firstMonthDate)
        let lastWeekday = Calendar.current.component(.weekday, from: lastMonthDate)

        let deltaBefore = -dayIndex(firstWeekday) + 1
        let deltaAfter = 7 - dayIndex(lastWeekday)
        
        firstCalDate = Calendar.current.date(byAdding: DateComponents(day: deltaBefore), to: firstMonthDate)!
        lastCalDate = Calendar.current.date(byAdding: DateComponents(day: deltaAfter), to: lastMonthDate)!
        
        let days = Calendar.current.dateComponents([.day], from: firstCalDate, to: lastCalDate).day! + 1
        weeks = days / 7
    }
    
    func getWeeks() -> [CalWeek] {
        var result = [CalWeek]()
        result.append(CalWeek(isHeader: true, days: getWeekHeaders()))
        for week in 0..<weeks {
            result.append(CalWeek(isHeader: false, days: getWeekDays(week)))
        }
        return result
    }
    
    private func getWeekDays(_ week: Int) -> [CalDay] {
        // TODO: optionals
        var date = Calendar.current.date(byAdding: DateComponents(day: week * 7), to: firstCalDate)!
        var calDays:[CalDay] = []
        for _ in 0...6 {
            let day = Calendar.current.dateComponents([.day], from: date).day ?? 0
            let fromMonth = date >= firstMonthDate && date <= lastMonthDate
            let calDay = CalDay(text: String(day), fromMonth: fromMonth, date: fromMonth ? date : nil)
            calDays.append(calDay)
            date = Calendar.current.date(byAdding: DateComponents(day: 1), to: date)!
        }
        return calDays
    }
    
    private func getWeekHeaders() -> [CalDay] {
        // TODO: Calendar.current.veryShortWeekdaySymbols
        let shortSymbols = ["S", "M", "T", "W", "T", "F", "S"]
        let delta = startOfWeek - 1
        var result: [CalDay] = []
        for i in 1...7 {
            var j = i + delta
            j = j <= 7 ? j : j - 7
            let calHeader = CalDay(text: shortSymbols[j-1], fromMonth: false, date: nil)
            result.append(calHeader)
        }
        return result
    }
    
    func browse(bySwipping component: Calendar.Component, toNext: Bool) -> CalMonth {
        // TODO optional
        let date = Calendar.current.date(byAdding: component, value: toNext ? 1 : -1, to: firstMonthDate)!
        return CalMonth(date: date, startOfWeek: startOfWeek)
    }
    
    func browseToday() -> CalMonth {
        return CalMonth(date: Date(), startOfWeek: startOfWeek)
    }
    
}

struct CalWeek {
    let isHeader: Bool
    let days: [CalDay]
}

struct CalDay {
    let text: String
    let fromMonth: Bool
    let date: Date?
}
