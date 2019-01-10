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
    let defaultStartOfWeek = 2

    init() {
        calMonth = CalMonth(date: Date())
        serviceCall()
    }
    
    // TODO: implement service
    func serviceCall() {
         dataSource.onNext(calMonth.getWeeks())
    }
    
    
}
