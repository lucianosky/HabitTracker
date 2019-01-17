//
//  NetworkService.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 15/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

final class HabitLogDB: Codable {
    var id: Int?
    var date: String
    var done: Bool
    
    init(date: String, done: Bool) {
        self.date = date
        self.done = done
    }
}

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    let currentHabitLog: PublishSubject<HabitLogDB> = PublishSubject()
    let currentHabitLogs: PublishSubject<[HabitLogDB]> = PublishSubject()

    private let baseURL = "https://habittrackervapor.vapor.cloud/api/"
    
    func getHabitLog(id: Int) {
        Alamofire.request("\(baseURL)habitlogs/\(id)")
            .responseData { [weak self] response in
                let decoder = JSONDecoder()
                let habit: Result<HabitLogDB> = decoder.decodeResponse(from: response)
                switch habit {
                case .success(let habitLogDB):
                    self?.currentHabitLog.onNext(habitLogDB)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getHabitLogs() {
        Alamofire.request("\(baseURL)habitlogs")
            .responseData { [weak self] response in
                let decoder = JSONDecoder()
                let habit: Result<[HabitLogDB]> = decoder.decodeResponse(from: response)
                switch habit {
                case .success(let habitLogs):
                    self?.currentHabitLogs.onNext(habitLogs)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
}

enum BackendError: Error {
    case parsing(reason: String)
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(BackendError.parsing(reason:
                "Did not get data in response"))
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}


