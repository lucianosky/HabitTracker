//
//  HabitTrackModel.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 11/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation

// TODO
import CoreData
import UIKit

enum HabitState {
    case none
    case done
    case notDone
}

private struct Constants {
    static let entityName = "HabitLog"
    static let datePredicate = "date = %@"
    //static let periodPredicate = "(date >= %@) AND (date <= %@)"
}

class HabitTrackModel {
    
    static let shared = HabitTrackModel()
    
    private var habitsDict = [Date: HabitState]()
    
    private init() {
        fetchAll()
    }

    func changeHabitState(date: Date) -> HabitState {
        let currentState = habitsDict[date] ?? .none
        let newState = switchState(currentState)
        habitsDict[date] = newState == .none ? nil : newState
        print(habitsDict)

        // TODO
        if newState == .none {
            delete(date: date)
        } else {
            udpate(date: date, habitState: newState)
        }
        
        // TODO: test for service return
        return newState
    }
    
    private func switchState(_ currentState: HabitState) -> HabitState {
        let newState: HabitState
        switch currentState {
        case .none: newState = .done
        case .done: newState = .notDone
        case .notDone: newState = .none
        }
        return newState
    }
    
    func getHabitState(date: Date) -> HabitState {
        guard let habitState = habitsDict[date] else {
            return .none
        }
        return habitState
    }
    
}

// MARK: - CoreData

extension HabitTrackModel {
    
    func udpate(date: Date, habitState: HabitState) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.entityName)
        let predicate = NSPredicate(format: Constants.datePredicate, date as CVarArg)
        let done = habitState == .done
        fetchRequest.predicate = predicate
        do {
            let records = try context.fetch(fetchRequest)
            if records.count == 1,  let habitLog = records[0] as? HabitLog {
                // update
                habitLog.setValue(done, forKeyPath: "done")
                try context.save()
            } else if records.count == 0 {
                // insert
                let entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: context)!
                let habitLog = NSManagedObject(entity: entity, insertInto: context)
                habitLog.setValue(date, forKeyPath: "date")
                habitLog.setValue(done, forKeyPath: "done")
                try context.save()
            } else {
                print("error in udpate")
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }

    func delete(date: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.entityName)
        let predicate = NSPredicate(format: Constants.datePredicate, date as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let records = try context.fetch(fetchRequest)
            if records.count == 1, let habitLog = records[0] as? HabitLog {
                context.delete(habitLog)
                try context.save()
            } else {
                print("error in delete")
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        do {
            if let habitLogs = try context.fetch(fetchRequest) as? [HabitLog] {
                habitsDict = [:]
                for habitLog in habitLogs {
                    if let date = habitLog.date {
                        habitsDict[date] = habitLog.done ? HabitState.done : HabitState.notDone
                    } else {
                        print("error in fetchAll")
                    }
                }
            } else {
                print("error in fetchAll")
            }
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
}
