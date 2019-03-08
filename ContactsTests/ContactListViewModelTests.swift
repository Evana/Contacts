//
//  ContactListViewModelTests.swift
//  ContactsTests
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import XCTest
@testable import Contacts
class ContactListViewModelTests: XCTestCase {

    var contactListViewModel: ContactListViewModel?
    var mockService: MockContactService?
    
    override func setUp() {
        super.setUp()
        mockService = MockContactService()
        contactListViewModel = ContactListViewModel(contactService: mockService!)
        contactListViewModel?.fetchContact()
        
    }
    
    override func tearDown() {
        mockService = nil
        contactListViewModel = nil
        super.tearDown()
    }
    
    func testFetchContact() {
        contactListViewModel?.fetchContact()
        XCTAssert(mockService!.isfetchContactCalled , "Fetched successfully")
    }
    
    func testFetchContactFail() {
        let error = CustomError.noNetwork 
        contactListViewModel?.fetchContact()
        mockService?.fetchFail(error:.system(error: error))
        XCTAssertEqual(self.contactListViewModel?.alertMessage, error.debugDescription)
    }
    
    func fetchContactFinish() {
        mockService?.contacts = StubContactsGenerator().stubContacts()
        contactListViewModel?.fetchContact()
        mockService?.fetchSuccess()
    }
    
    func testGetCellViewModel() {
        fetchContactFinish()
        let indexPath = IndexPath(row: 0, section: 0)
        let cellViewModel = contactListViewModel?.getCellViewModel(at: indexPath)
        let sortedContacts = mockService?.contacts.sorted{ $0.firstName < $1.firstName }
        let contact = sortedContacts?[indexPath.row]
        XCTAssertEqual(cellViewModel?.name, "\(contact!.firstName) \(contact!.lastName)" )
    }
    
    func testCreateCellViewModel() {
        fetchContactFinish()
        let indexPath = IndexPath(row: 4, section: 0)
        let contact = mockService?.contacts[indexPath.row]
        let cellViewModel = contactListViewModel?.createCellViewModel(contact: contact!)
        XCTAssertEqual(cellViewModel?.email, "\(contact?.email ?? "")")
    }
}

class MockContactService: ContactServiceManager {
    
    var isfetchContactCalled = false
    var contacts = [Contact]()
    var completeClouser: ((Result<[Contact], CustomError>) -> ())?
    
    func fetchContacts(url: String, completion: @escaping (Result<[Contact], CustomError>) -> ()) {
        isfetchContactCalled = true
        completeClouser = completion
    }
    
    func fetchFail(error: CustomError) {
        completeClouser? (.failure(.noNetwork))
    }
    
    func fetchSuccess() {
        completeClouser?(.success(contacts))
    }
}

class StubContactsGenerator {
    func stubContacts() -> [Contact] {
        let path = Bundle.main.path(forResource: "contacts", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        let contacts = try! decoder.decode([Contact].self, from: data)
        return contacts
    }
}
