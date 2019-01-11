//
//  HabitTrackModel.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 11/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation

enum HabitState {
    case none
    case done
    case notDone
}

class HabitTrackModel {
    
    static let shared = HabitTrackModel()
    
    private var habitsDict = [Date: HabitState]()
    
    private init() {
    }

    func setHabitState(date: Date) -> (Bool, HabitState) {
        let habitState = habitsDict[date]
        if habitState == nil {
            habitsDict[date] = .done
        } else {
            switch habitState! {
            case .none: habitsDict[date] = .done // TODO - LOG @ firebase, should not happen
            case .done: habitsDict[date] = .notDone
            case .notDone: habitsDict[date] = nil
            }
        }
        // TODO: test for service return
        // TODO ---> REVIEW
        return (true, habitsDict[date] ?? .none)
    }
    
    func getHabitState(date: Date) -> HabitState {
        guard let habitState = habitsDict[date] else {
            return .none
        }
        return habitState
    }
    
    // TODO
    func temporaryFuncGetDict() -> [Date: HabitState] {
        return habitsDict
    }
    
}
