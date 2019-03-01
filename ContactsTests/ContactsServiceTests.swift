//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsServiceTests: XCTestCase {

    var contactService: ContactService?
    
    override func setUp() {
        super.setUp()
        contactService = ContactService()
    }
    
    override func tearDown() {
        contactService = nil
        super.tearDown()
    }
    
    func testFetchContacts() {
        let expectation = XCTestExpectation(description: "callBack")
        let fetchExpectation = XCTestExpectation(description: "fetchContacts")
        
        contactService?.fetchContacts { (success, contacts, error) in
            expectation.fulfill()
            if let contacts = contacts {
                for contact in contacts {
                    XCTAssertNotNil(contact.id)
                }
                fetchExpectation.fulfill()
            }
        }
        
        wait(for: [expectation, fetchExpectation], timeout: 2)
    }
}
