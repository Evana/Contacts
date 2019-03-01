//
//  Contact.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let gender: Gender
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case gender
    }
}
