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

class CalMonthSpec: QuickSpec {

    override func spec() {
        
        var calMonth: CalMonth!
        
        describe("browsing january 2019") {

            var firstMonthDate: Date!

            beforeEach {
                calMonth = CalMonth.init(year: 2019, month: 1)
            }
            
            context("to next month") {
                it("should take to february") {
                    calMonth = calMonth.browse(bySwipping: .month, toNext: true)
                    firstMonthDate = Date.fromComponents(year: 2019, month: 2, day: 1)
                }
            }
            
            context("to previous month") {
                it("should take to december") {
                    calMonth = calMonth.browse(bySwipping: .month, toNext: false)
                    firstMonthDate = Date.fromComponents(year: 2018, month: 12, day: 1)
                }
            }
            
            context("to next year") {
                it("should take to january 2020") {
                    calMonth = calMonth.browse(bySwipping: .year, toNext: true)
                    firstMonthDate = Date.fromComponents(year: 2020, month: 1, day: 1)
                }
            }
            
            context("to previous year") {
                it("should take to january 2018") {
                    calMonth = calMonth.browse(bySwipping: .year, toNext: false)
                    firstMonthDate = Date.fromComponents(year: 2018, month: 1, day: 1)
                }
            }
            
            afterEach {
                expect(calMonth.firstMonthDate).to(equal(firstMonthDate))
                calMonth = calMonth.browseToday()
                expect(calMonth.firstMonthDate).to(equal(Date.fromComponents(year: 2019, month: 1, day: 1)))
            }

        }

    }

}

