//
//  ContactService.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

protocol ContactServiceProtocol {
    func fetchContacts(completion: @escaping(_ success: Bool, _ contacts: [Contact]?, _ error: Error?) -> ())
}

class ContactService: ContactServiceProtocol {
    
    let apiUrl = URL(string: "https://gist.githubusercontent.com/pokeytc/e8c52af014cf80bc1b217103bbe7e9e4/raw/4bc01478836ad7f1fb840f5e5a3c24ea654422f7/contacts.json")
    
    func fetchContacts(completion: @escaping(_ success: Bool, _ contacts: [Contact]?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: apiUrl!) { data, response, error in
            guard let data = data else {
                if let error = error  {
                    completion(false, nil, error )
                }
                return
            }
            do {
                let contacts = try JSONDecoder().decode([Contact].self, from: data)
                completion(true, contacts, nil )
            } catch let jsonErr {
                completion(false, nil, jsonErr )
            }
            }.resume()
    }
    
}
