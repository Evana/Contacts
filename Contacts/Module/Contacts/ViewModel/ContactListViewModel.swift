//
//  ContactListViewModel.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import Foundation

class ContactListViewModel {
    
    struct Constant {
        static let apiUrl = "https://gist.githubusercontent.com/pokeytc/e8c52af014cf80bc1b217103bbe7e9e4/raw/4bc01478836ad7f1fb840f5e5a3c24ea654422f7/contacts.json"
    }
   
    var contacts: [Contact]?
    
    let contactService: ContactServiceManager
    
    private var allCellCount = 0
    private var favoriteCellCount = 0

    var numberOfCells: Int {
        return isFavorite ? favoriteCellCount : allCellCount
    }
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    private var cellViewModels: [ContactCellViewModel]? {
        didSet {
            reloadCollectionViewClosure?()
        }
    }
    
    private var favoriteCellViewCodels:[ContactCellViewModel]?

    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteCellViewCodels = cellViewModels?.filter { $0.isFavorite == true }
                favoriteCellCount = favoriteCellViewCodels?.count ?? 0
            }
            reloadCollectionViewClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClosure: (()->())?
    
    init(contactService: ContactServiceManager = ContactService()) {
        self.contactService = contactService
    }
    
    func fetchContact() {
        isLoading = true
        contactService.fetchContacts(url: ContactListViewModel.Constant.apiUrl){ [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let contacts):
                self.processContacts(contacts: contacts)
            case .failure(let error): do {
                self.alertMessage = error.debugDescription
                
                }
            }
        }
    }
    
    private func processContacts(contacts: [Contact]) {
        self.contacts = contacts
        var viewModels = [ContactCellViewModel]()
        for contact in contacts {
            viewModels.append(createCellViewModel(contact: contact))
        }
        let sortedContacts = viewModels.sorted { $0.name < $1.name }
        allCellCount = viewModels.count 
        cellViewModels = sortedContacts
    }
    
    func createCellViewModel( contact: Contact ) -> ContactCellViewModel {
        return ContactCellViewModel(avatarImage: contact.gender == .male ? "male_avatar" : "female_avatar", name: "\(contact.firstName) \(contact.lastName)", email: contact.email, isFavorite: contact.isFavorite)
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ContactCellViewModel? {
        return isFavorite ? favoriteCellViewCodels?[indexPath.row] : cellViewModels?[indexPath.row]
    }
    
    func updateFavorite(for indexPath: IndexPath) {
        if let isfavorite = contacts?[indexPath.row].isFavorite {
            contacts?[indexPath.row].isFavorite = !isfavorite
            cellViewModels?[indexPath.row].isFavorite = !isfavorite
        }
    }
}

struct ContactCellViewModel {
    let avatarImage: String
    let name: String
    let email: String
    var isFavorite: Bool
}
