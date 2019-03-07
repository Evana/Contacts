//
//  CustomError.swift
//  Contacts
//
//  Created by Evana Islam on 7/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

enum CustomError: Error, CustomDebugStringConvertible {
    case noNetwork
    case system(error: Error)
    case decoding(data: Data, error: Error)
    case invalidUrl(urlString: String)
    case unknown
    
    // Description for debugging purpose.
    var debugDescription: String {
        switch self {
        case .noNetwork:
            return "Network appears to be offline"
        case .system(error: let error):
            return String(describing: error)
        case .decoding(data: let data, error: let error):
            return ["decoding error", String(describing: error), String(data: data, encoding: .utf8)]
                .compactMap { $0 }
                .joined(separator: " ")
        case .invalidUrl(urlString: let urlString):
            return "invalid url \(urlString)"
        case .unknown:
            return "unknown error"
        }
        
    }
    
}
