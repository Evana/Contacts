//
//  ContactListViewModel.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

class ContactListViewModel {
    let contactService: ContactServiceProtocol
    var contacts: [Contact]?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( contactService: ContactServiceProtocol = ContactService()) {
        self.contactService = contactService
    }
    
    
    func fetchContact() {
        self.isLoading = true
        contactService.fetchContacts { [weak self] success, contacts, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                guard let contacts = contacts else {
                    self.alertMessage = "Something went wrong"
                    return
                }
            }
        }
    }
}
