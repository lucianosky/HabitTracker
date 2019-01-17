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
        
        beforeEach {
            calMonth = CalMonth(date: Date())
        }
        
        describe("calendar") {
            context("january") {
                it("should have 5 weeks") {
                    calMonth = CalMonth.init(year: 2019, month: 1)
                    expect(calMonth.weeks).to(equal(5))
                }
            }
        }
    }

}

