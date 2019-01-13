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

    let dataSource: PublishSubject<[CalWeek]> = PublishSubject()
    let currentDate: PublishSubject<Date> = PublishSubject()
    let changedState: PublishSubject<(Date, HabitState)> = PublishSubject()

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
    
    func changeHabitState(date: Date) {
        // TODO: async return from service
        let habitState = HabitTrackModel.shared.changeHabitState(date: date)
        changedState.onNext((date, habitState))
    }
    
    func getHabitState(date: Date) -> HabitState {
        return HabitTrackModel.shared.getHabitState(date: date)
    }
    
    func changeStartOfWeek(tag: Int) {
        var newStartOfWeek = calMonth.startOfWeek + tag - 1
        if newStartOfWeek > 7 {
            newStartOfWeek -= 7
        }
        calMonth = CalMonth(date: calMonth.firstMonthDate, startOfWeek: newStartOfWeek)
        emit()
    }
    
}
