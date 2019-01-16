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

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    let publisher: PublishSubject<HabitLog2> = PublishSubject()
    
    func getHabitLog2() {
        Alamofire.request("https://habittrackervapor.vapor.cloud/api/habitlogs/1")
            .responseData { [weak self] response in
                let decoder = JSONDecoder()
                let habit: Result<HabitLog2> = decoder.decodeResponse(from: response)
                switch habit {
                case .success(let habitLog2):
                    self?.publisher.onNext(habitLog2)
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

final class HabitLog2: Codable {
    var id: Int?
    var date: String
    var done: Bool
    
    init(date: String, done: Bool) {
        self.date = date
        self.done = done
    }
}
