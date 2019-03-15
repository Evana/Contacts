//
//  CacheManager.swift
//  Contacts
//
//  Created by Evana Islam on 16/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

// Note: This is not beong use anywhere now
import Foundation

class CacheManager: ServiceManager {
    
    var values: [String: Data] = [:]
    
    enum CodingKeys: String, CodingKey {
        case values
    }
    
    func add(urlString: String, completion: ((Result<Data, CustomError>) -> Void)? = nil) {
        if let value = values[urlString] {
            completion?(.success(value))
        } else {
            responseData(urlString: urlString) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let data):
                        strongSelf.values[urlString] = data
                        completion?(.success(data))
                    case .failure(let error):
                        completion?(.failure(error))
                        
                    }
                }
            }
        }
    }
    
}
