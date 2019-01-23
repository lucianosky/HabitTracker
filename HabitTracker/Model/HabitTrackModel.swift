//
//  HabitTrackModel.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 11/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import CoreData

enum HabitState {
    case none
    case done
    case notDone
}

private struct Constants {
    static let entityName = "HabitLog"
    static let datePredicate = "yyyymmdd = %@"
}

class HabitTrackModel {
    
    static let shared = HabitTrackModel()
    
    private var habitsDict = [String: HabitState]()
    
    private init() {
        // TODO: testar status
        _ = fetchAll()
    }

    func changeHabitState(yyyymmdd: String) -> HabitState {
        let currentState = habitsDict[yyyymmdd] ?? .none
        let newState = switchState(currentState)
        habitsDict[yyyymmdd] = newState == .none ? nil : newState

        // TODO: test for Core Data status
        if newState == .none {
            _ = delete(yyyymmdd: yyyymmdd)
        } else {
            _ = udpate(yyyymmdd: yyyymmdd, habitState: newState)
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
    
    func getHabitState(yyyymmdd: String) -> HabitState {
        guard let habitState = habitsDict[yyyymmdd] else {
            return .none
        }
        return habitState
    }
    
}

// MARK: - CoreData

extension HabitTrackModel {
    
    func udpate(yyyymmdd: String, habitState: HabitState) -> Bool {
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.entityName)
        let predicate = NSPredicate(format: Constants.datePredicate, yyyymmdd as CVarArg)
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
                habitLog.setValue(yyyymmdd, forKeyPath: "yyyymmdd")
                habitLog.setValue(done, forKeyPath: "done")
                try context.save()
            } else {
                print("error in udpate")
                FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "udpate")
                return false
            }
        } catch let error as NSError {
            
            // TODO: log error message
            // TODO: FirebaseHelper.error -> save "ERROR"
            
            print("Could not update. \(error), \(error.userInfo)")
            FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "udpate")
            return false
        }
        return true
    }

    func delete(yyyymmdd: String) -> Bool {
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.entityName)
        let predicate = NSPredicate(format: Constants.datePredicate, yyyymmdd as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let records = try context.fetch(fetchRequest)
            if records.count == 1, let habitLog = records[0] as? HabitLog {
                context.delete(habitLog)
                try context.save()
            } else {
                FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "delete")
                print("error in delete")
                return false
            }
        } catch let error as NSError {
            FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "delete")
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func fetchAll() -> Bool {
        var result = true
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        do {
            if let habitLogs = try context.fetch(fetchRequest) as? [HabitLog] {
                habitsDict = [:]
                for habitLog in habitLogs {
                    if let yyyymmdd = habitLog.yyyymmdd {
                        habitsDict[yyyymmdd] = habitLog.done ? HabitState.done : HabitState.notDone
                    } else {
                        result = false
                        FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "fetchAll")
                        print("error in fetchAll")
                    }
                }
            } else {
                result = false
                FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "fetchAll")
                print("error in fetchAll")
            }
        } catch let error as NSError {
            result = false
            FirebaseHelper.shared.error(theClass: HabitTrackModel.typeName, onCoreDataHelper: "fetchAll")
            print("Could not list. \(error), \(error.userInfo)")
        }
        return result
    }
    
}

extension HabitTrackModel: NameDescribable {}
