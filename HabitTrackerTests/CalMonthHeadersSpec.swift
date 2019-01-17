//
//  CalMonthSpec.swift
//  HabitTrackerTests
//
//  Created by Luciano Sclovsky on 17/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Quick
import Nimble

@testable import HabitTracker

class CalMonthHeaderSpec: QuickSpec {

    override func spec() {
        
        let calMonth = CalMonth(year: 2019, month: 1)
        
        describe("january 2019 weeks") {

            let weeks = calMonth.getWeeks()

            context("header") {
                it("should range from Sunday to Saturday letters") {
                    let week = weeks[0]
                    expect(week.isHeader).to(beTrue())
                    let symbols = ["S", "M", "T", "W", "T", "F", "S"]
                    for i in 0...6 {
                        let day = week.days[i]
                        expect(day.text).to(equal(symbols[i]))
                        expect(day.fromMonth).to(equal(false))
                        expect(day.date).to(beNil())
                    }
                }
            }

            context("weeks") {
                it("should range from Dec/03 to Feb/02") {
                    var date = Date.fromComponents(year: 2018, month: 12, day: 30)
                    for i in 1...5 {
                        let week = weeks[i]
                        expect(week.isHeader).to(beFalse())
                        for j in 0...6 {
                            let day = week.days[j]
                            let components = Calendar.current.dateComponents([.month, .day], from: date)
                            expect(day.text).to(equal(String(components.day!)))
                            if components.month == 1 {
                                expect(day.date).to(equal(date))
                                expect(day.fromMonth).to(beTrue())
                            } else {
                                expect(day.date).to(beNil())
                                expect(day.fromMonth).to(beFalse())
                            }
                            date = date.addDays(1)
                        }
                    }
                }
            }

        }
        
        
    }

}

