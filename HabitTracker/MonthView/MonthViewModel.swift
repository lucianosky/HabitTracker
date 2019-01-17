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

    private let disposeBag = DisposeBag()

    init() {
        calMonth = CalMonth(date: Date())
        createBinds()
        serviceCall()
    }
    
    func createBinds() {
        NetworkService.shared.publisher.subscribe(onNext: { (habitLog2) in
            print(habitLog2)
        }).disposed(by: self.disposeBag)
    }
    
    // TODO: implement service
    func serviceCall() {
        NetworkService.shared.getHabitLog2()
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
        let habitState = HabitTrackModel.shared.changeHabitState(yyyymmdd: date.yyyymmdd)
        changedState.onNext((date, habitState))
    }
    
    func getHabitState(date: Date) -> HabitState {
        return HabitTrackModel.shared.getHabitState(yyyymmdd: date.yyyymmdd)
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
