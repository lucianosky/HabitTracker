//
//  MonthViewModel.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 10/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import RxSwift

class MonthViewModel {
    
    private var calMonth: CalMonth
    private let defaultStartOfWeek = 2

    let dataSource: PublishSubject<[CalWeek]> = PublishSubject()
    let currentDate: PublishSubject<Date> = PublishSubject()

    init() {
        calMonth = CalMonth(date: Date())
        serviceCall()
    }
    
    // TODO: implement service
    func serviceCall() {
        emit()
    }
    
    func browse(bySwipping component: Calendar.Component, toNext: Bool) {
        calMonth = calMonth.browse(bySwipping: component, toNext: toNext)
        emit()
    }
    
    func browseToday() {
        calMonth = calMonth.browseToday()
        emit()
    }
    
    private func emit() {
        dataSource.onNext(calMonth.getWeeks())
        currentDate.onNext(calMonth.firstMonthDate)
    }
    
    
}
