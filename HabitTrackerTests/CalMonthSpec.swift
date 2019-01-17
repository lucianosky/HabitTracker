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
        var firstCalDate: Date!
        var lastCalDate: Date!
        
        describe("january") {

            context("starting default Sunday") {
                it("should have 5 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1)
                    firstCalDate = Date.fromComponents(year: 2018, month: 12, day: 30)
                    lastCalDate = Date.fromComponents(year: 2019, month: 2, day: 2)
                    expect(calMonth.weeks).to(equal(5))
                    expect(calMonth.startOfWeek).to(equal(1))
                }
            }

            context("starting Monday") {
                it("should have 5 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1, startOfWeek: 2)
                    firstCalDate = Date.fromComponents(year: 2018, month: 12, day: 31)
                    lastCalDate = Date.fromComponents(year: 2019, month: 2, day: 3)
                    expect(calMonth.startOfWeek).to(equal(2))
                    expect(calMonth.weeks).to(equal(5))
                }
            }

            context("starting Tuesday") {
                it("should have 5 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1, startOfWeek: 3)
                    firstCalDate = Date.fromComponents(year: 2019, month: 1)
                    lastCalDate = Date.fromComponents(year: 2019, month: 2, day: 4)
                    expect(calMonth.startOfWeek).to(equal(3))
                    expect(calMonth.weeks).to(equal(5))
                }
            }

            context("starting Wednesday") {
                it("should have 6 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1, startOfWeek: 4)
                    firstCalDate = Date.fromComponents(year: 2018, month: 12, day: 26)
                    lastCalDate = Date.fromComponents(year: 2019, month: 2, day: 5)
                    expect(calMonth.startOfWeek).to(equal(4))
                    expect(calMonth.weeks).to(equal(6))
                }
            }

            context("starting Thursday") {
                it("should have 6 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1, startOfWeek: 5)
                    firstCalDate = Date.fromComponents(year: 2018, month: 12, day: 27)
                    lastCalDate = Date.fromComponents(year: 2019, month: 2, day: 6)
                    expect(calMonth.startOfWeek).to(equal(5))
                    expect(calMonth.weeks).to(equal(6))
                }
            }

            context("starting Friday") {
                it("should have 5 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1, startOfWeek: 6)
                    firstCalDate = Date.fromComponents(year: 2018, month: 12, day: 28)
                    lastCalDate = Date.fromComponents(year: 2019, month: 1, day: 31)
                    expect(calMonth.startOfWeek).to(equal(6))
                    expect(calMonth.weeks).to(equal(5))
                }
            }
            
            context("starting Saturday") {
                it("should have 5 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1, startOfWeek: 7)
                    firstCalDate = Date.fromComponents(year: 2018, month: 12, day: 29)
                    lastCalDate = Date.fromComponents(year: 2019, month: 2, day: 1)
                    expect(calMonth.startOfWeek).to(equal(7))
                    expect(calMonth.weeks).to(equal(5))
                }
            }
            
            afterEach {
                expect(calMonth.firstCalDate).to(equal(firstCalDate))
                expect(calMonth.lastCalDate).to(equal(lastCalDate))
            }
            
        }
        
        
    }

}

