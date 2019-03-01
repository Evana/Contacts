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
    var mockService: MockApiService?
    
    override func setUp() {
        super.setUp()
        mockService = MockApiService()
        contactListViewModel = ContactListViewModel(contactService: mockService!)
        
    }
    
    override func tearDown() {
        mockService = nil
        contactListViewModel = nil
        super.tearDown()
    }
    
    func testFetchPhotos() {
        contactListViewModel?.fetchContact()
        XCTAssert(mockService!.isfetchContactCalled , "Fetched successfully")
    }
    
    func testFetchPhotoFail() {
        let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Failed to fetch contacts"])
        contactListViewModel?.fetchContact()
        mockService?.fetchFail(error: error)
        XCTAssertEqual(self.contactListViewModel?.alertMessage, error.localizedDescription)
    }
}

class MockApiService: ContactServiceProtocol {
    
    var isfetchContactCalled = false
    var contacts = [Contact]()
    var completeClouser: ((_ success: Bool, _ contacts: [Contact], _ error: Error?) -> ())?
    
    func fetchContacts(completion: @escaping (_ success: Bool, _ contacts: [Contact]?, _ error: Error?) -> ()) {
        isfetchContactCalled = true
        completeClouser = completion
    }
    
    func fetchFail(error: Error) {
        completeClouser? (false, [Contact](), error)
    }
    
    func fetchSuccess() {
        completeClouser?(true, contacts, nil)
    }
}