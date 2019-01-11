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

//    func setHabit(date: Date, state: HabitState) {
  
    //        if currentState == nil && state == .none { return }
    //        if currentState == state && state != .none { return }
    //        habitsDict[date] = state
    
    //        if currentState == nil {
    //            if state == .none {
    //                return
    //            } else {
    //                habitsDict[date] = state
    //            }
    //        } else {
    //            if state == .none {
    //                habitsDict[date] = state
    //            } else {
    //                if currentState == state {
    //                    return
    //                } else {
    //                    habitsDict[date] = state
    //                }
    //            }
    //        }

    func setHabit(date: Date) -> (Bool, HabitState) {
        let currentState = habitsDict[date]
        if currentState == nil {
            habitsDict[date] = .done
        } else {
            switch currentState! {
            case .none: habitsDict[date] = nil // TODO - should not happen
            case .done: habitsDict[date] = .notDone
            case .notDone: habitsDict[date] = nil
            }
        }
        // TODO: test for service return
        // TODO ---> REVIEW
        return (true, habitsDict[date] ?? .none)
    }
    
    func getHabit(date: Date) -> HabitState {
        guard let currentState = habitsDict[date] else {
            return .none
        }
        return currentState
    }
    
    // TODO
    func temporaryFuncGetDict() -> [Date: HabitState] {
        return habitsDict
    }
    
}
