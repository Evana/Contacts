//
//  ContactService.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchContacts(completion: @escaping(_ success: Bool, _ contacts: [Contact]?, _ error: Error?) -> ())
}

class ContactService: ServiceManager {
    
   static func fetchContacts(url: String, completion: @escaping(Result<[Contact], CustomError>) -> ()) {
        responseObject(urlString: url, completion: completion)
    }
    
}
