//
//  NetworkService.swift
//  Contacts
//
//  Created by Evana Islam on 7/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

enum Result<Value, error:Error> {
    
    case success(Value)
    case failure(error)
}

// MARK: - CustomStringConvertible

extension Result: CustomStringConvertible, CustomDebugStringConvertible {
    
    var description: String {
        switch self {
        case .success:
            return "SUCCESS"
            
        case .failure:
            return "FAILURE"
        }
    }
    
    var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
            
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

protocol ServiceManager {}

extension ServiceManager {
    func responseData(urlString: String,
                             completion: @escaping (Result<Data, CustomError>) -> Void) {
        guard let url = URL(string: urlString) else { return completion(.failure(.invalidUrl(urlString: urlString))) }
        URLSession.shared.dataTask(with: URLRequest(url: url)) {(data, response, error) in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                if (error as NSError).domain == NSURLErrorDomain,
                    (error as NSError).code == NSURLErrorNotConnectedToInternet
                {
                    completion(.failure(.noNetwork))
                } else {
                    completion(.failure(.system(error: error)))
                }
            } else {
                completion(.failure(.unknown))
            }
            }.resume()
    }
    
    func responseObject<T: Decodable>(urlString: String,
                                             completion: @escaping (Result<T, CustomError>) -> Void) {
        // T is any type which can be decodable to convert the response from backend.
        responseData(urlString: urlString,
                     completion: { result in
                        switch result {
                        case .success(let data):
                            
                            // decoding response data.
                            let jsonDecoder = JSONDecoder()
                            do {
                                let response = try jsonDecoder.decode(T.self, from: data)
                                completion(.success(response))
                            } catch let error as DecodingError {
                                completion(.failure(.decoding(data: data, error: error)))
                            } catch {
                                completion(.failure(.system(error: error)))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
        })
    }
}
