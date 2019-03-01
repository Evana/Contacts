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
    
    private var cellViewModels: [ContactCellViewModel] = [ContactCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClosure: (()->())?

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
                self.processContacts(contacts: contacts)
            }
        }
    }
    
    private func processContacts(contacts: [Contact]) {
        self.contacts = contacts
        var viewModels = [ContactCellViewModel]()
        for contact in contacts {
            viewModels.append(createCellViewModel(contact: contact))
        }
        cellViewModels = viewModels
    }
    
    private func createCellViewModel( contact: Contact ) -> ContactCellViewModel {
        #warning("Need to put Avatar image")
        return ContactCellViewModel(avatarImage: contact.gender.rawValue, name: "\(contact.firstName) \(contact.lastName)", email: contact.email, isFavorite: contact.isFavorite)
    }
}

struct ContactCellViewModel {
    let avatarImage: String
    let name: String
    let email: String
    var isFavorite: Bool
}
