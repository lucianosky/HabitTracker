//
//  FirebaseHelper.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 20/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import Firebase
import Fabric

private struct Constants {
    static let defaultStartOfWeek = 1
    static let viewParameter = "VIEW"
    static let viewDidLoad = "VIEW_DID_LOAD"
    static let warning = "WARNING"
    static let theClass = "CLASS"
    static let message = "MESSAGE"
}

struct AppConfiguration {
    var startOfWeek: Int
    
    init() {
        startOfWeek = Constants.defaultStartOfWeek
    }
}

class FirebaseHelper {
    
    static let shared = FirebaseHelper()
    
    private init() {}
    
    public private(set) var appConfiguration = AppConfiguration()
    
    func config(complete: @escaping () -> Void ) {
        FirebaseApp.configure()
        loadRemoteConfigurations(){
            complete()
        }
    }
    
    private func loadRemoteConfigurations(complete: @escaping () -> Void ) {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        
        func readPropertyNumber(_ key: String, _ defaultValue: Int) -> Int {
            guard let value = remoteConfig.configValue(forKey: key).numberValue else {
                warning(theClass: String(describing: self), message: "Remote config with null value: \(key)")
                return defaultValue
            }
            let valueInt = Int(truncating: value)
            if valueInt == 0 {
                warning(theClass: String(describing: self), message: "Remote config with zero value: \(key)")
                return defaultValue
            }
            return valueInt
        }
        
        func readPropertyString(_ key: String, _ defaultValue: String) -> String {
            guard let value = remoteConfig.configValue(forKey: key).stringValue else {
                warning(theClass: String(describing: self), message: "Remote config with null value: \(key)")
                return defaultValue
            }
            if value == "" {
                warning(theClass: String(describing: self), message: "Remote config with empty value: \(key)")
                return defaultValue
            }
            return value
        }
        
        // for debug purposes
        // remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { [weak self] remoteConfigFetchStatus, error in
        
        remoteConfig.fetch(completionHandler: { [weak self] remoteConfigFetchStatus, error in
            remoteConfig.activateFetched()
            self?.appConfiguration.startOfWeek = readPropertyNumber("START_OF_WEEK", Constants.defaultStartOfWeek)
            complete()
        })
    }

    // func crash() {
    //     Crashlytics.sharedInstance().crash()
    // }
    
    func warning(theClass: String, message: String) {
        print("warning: \(message)")
        Analytics.logEvent(Constants.warning, parameters: [Constants.theClass : theClass, Constants.message: message])
    }
    
    func logEvent(event: String, parameters: [String : Any] = [:]) {
        print("logEvent: \(event)")
        Analytics.logEvent(event, parameters: parameters)
    }

    func logEvent(view: String) {
        print("logEvent viewDidLoad: \(view)")
        Analytics.logEvent(Constants.viewDidLoad, parameters: [Constants.viewParameter : view])
    }
    
}
