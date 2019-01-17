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
                    let symbols = ["S", "M", "T", "W", "T", "F", "S"]
                    for i in 0...6 {
                        let day = week.days[i]
                        expect(day.text).to(equal(symbols[i]))
                        expect(day.fromMonth).to(equal(false))
                        expect(day.date).to(beNil())
                    }
                }
            }

        }
        
        
    }

}

