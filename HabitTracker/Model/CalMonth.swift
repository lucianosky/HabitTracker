//
//  CalMonth.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 05/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation

private struct Constants {
    struct DateComponensError {
        static let year = 2019
        static let month = 1
    }
    static let theClass = "CalMonth"
}

struct CalMonth {
    
    let firstMonthDate: Date
    let lastMonthDate: Date
    let firstCalDate: Date
    let lastCalDate: Date
    let weeks: Int
    let startOfWeek: Int

    init (date: Date, startOfWeek: Int = 1) {
        var components = Calendar.current.dateComponents([.year, .month], from: date)
        if let year = components.year, let month = components.month {
            self.init(year: year, month: month, startOfWeek: startOfWeek)
        } else {
            // TODO: unexpected date handling error, warn user
            FirebaseHelper.shared.warning(theClass: Constants.theClass, unexpectedNullValue: "CalMonth init")
            self.init(year: Constants.DateComponensError.year, month: Constants.DateComponensError.month, startOfWeek: startOfWeek)
        }
    }
    
    init(year: Int, month: Int, startOfWeek: Int = 1) {
        
        func dayIndex(_ day: Int) -> Int {
            var index = day - (startOfWeek - 1)
            index = index > 0 ? index : index + 7
            return index
        }
        
        self.startOfWeek = startOfWeek
        
        firstMonthDate = Date.fromComponents(year: year, month: month)
        if let last = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: firstMonthDate) {
            lastMonthDate = last
        } else {
            // TODO: unexpected date handling error, warn user
            FirebaseHelper.shared.warning(theClass: Constants.theClass, unexpectedNullValue: "CalMonth init")
            lastMonthDate = firstMonthDate
        }

        let firstWeekday = Calendar.current.component(.weekday, from: firstMonthDate)
        let lastWeekday = Calendar.current.component(.weekday, from: lastMonthDate)

        let deltaBefore = -dayIndex(firstWeekday) + 1
        let deltaAfter = 7 - dayIndex(lastWeekday)
        
        if let first = Calendar.current.date(byAdding: DateComponents(day: deltaBefore), to: firstMonthDate),
            let last = Calendar.current.date(byAdding: DateComponents(day: deltaAfter), to: lastMonthDate) {
            firstCalDate = first
            lastCalDate = last
        } else {
            // TODO: unexpected date handling error, warn user
            FirebaseHelper.shared.warning(theClass: Constants.theClass, unexpectedNullValue: "CalMonth init")
            firstCalDate = firstMonthDate
            lastCalDate = firstMonthDate
        }
        
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
        var calDays:[CalDay] = []
        var error = false
        if var date = Calendar.current.date(byAdding: DateComponents(day: week * 7), to: firstCalDate) {
            for _ in 0...6 {
                let day = Calendar.current.dateComponents([.day], from: date).day ?? 0
                if day == 0 { error = true }
                let fromMonth = date >= firstMonthDate && date <= lastMonthDate
                let calDay = CalDay(text: String(day), fromMonth: fromMonth, date: fromMonth ? date : nil)
                calDays.append(calDay)
                if let nextDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: date) {
                    date = nextDate
                } else { error = true }
            }
        } else { error = true }
        if error {
            // TODO: unexpected date handling error, warn user
            FirebaseHelper.shared.warning(theClass: Constants.theClass, unexpectedNullValue: "getWeekDays")
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
        if let date = Calendar.current.date(byAdding: component, value: toNext ? 1 : -1, to: firstMonthDate) {
            return CalMonth(date: date, startOfWeek: startOfWeek)
        } else {
            // TODO: unexpected date handling error, warn user
            FirebaseHelper.shared.warning(theClass: Constants.theClass, unexpectedNullValue: "browse")
            return self
        }
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
