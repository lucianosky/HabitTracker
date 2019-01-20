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
                // nonCriticalError("Remote config with null value: \(key)")
                return defaultValue
            }
            let valueInt = Int(truncating: value)
            if valueInt == 0 {
                // nonCriticalError("Remote config with zero value: \(key)")
                return defaultValue
            }
            return valueInt
        }
        
        func readPropertyString(_ key: String, _ defaultValue: String) -> String {
            guard let value = remoteConfig.configValue(forKey: key).stringValue else {
                // nonCriticalError("Remote config with null value: \(key)")
                return defaultValue
            }
            if value == "" {
                // nonCriticalError("Remote config with empty value: \(key)")
                return defaultValue
            }
            return value
        }
        
        // for debug purposes: fetch(withExpirationDuration: 0
        remoteConfig.fetch(completionHandler: { [weak self] remoteConfigFetchStatus, error in
            remoteConfig.activateFetched()
            self?.appConfiguration.startOfWeek = readPropertyNumber("START_OF_WEEK", Constants.defaultStartOfWeek)
            complete()
        })
    }


    
}
