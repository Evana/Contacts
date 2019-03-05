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
    
    private var allCellCount = 0
    private var favoriteCellCount = 0

    var numberOfCells: Int {
        return isFavorite ? favoriteCellCount : allCellCount
    }
    
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
    
    private var cellViewModels: [ContactCellViewModel]? {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    private var favoriteCellViewCodels:[ContactCellViewModel]?

    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteCellViewCodels = cellViewModels?.filter { $0.isFavorite == true }
                favoriteCellCount = favoriteCellViewCodels?.count ?? 0
            }
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
        let sortedContacts = viewModels.sorted { $0.name < $1.name }
        allCellCount = viewModels.count > 20 ? 20 : viewModels.count
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
    
    func loadMoreCell() -> Bool {
        guard let viewModels = cellViewModels else { return false }
        allCellCount += 20
        var isEnabled = true
        if allCellCount > viewModels.count {
            allCellCount = viewModels.count
            isEnabled = false
        }
        self.reloadCollectionViewClosure?()
        return isEnabled
    }
}

struct ContactCellViewModel {
    let avatarImage: String
    let name: String
    let email: String
    var isFavorite: Bool
}
