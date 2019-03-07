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

    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchContacts() {
        let expectation = XCTestExpectation(description: "callBack")
        let fetchExpectation = XCTestExpectation(description: "fetchContacts")
        
        ContactService.fetchContacts(url: ContactListViewModel.apiUrl) { result in
            expectation.fulfill()
            switch result {
            case .success(let contacts):
                for contact in contacts {
                    XCTAssertNotNil(contact.id)
                }
                fetchExpectation.fulfill()
            case .failure(_):
                break
            }
        }
       
        
        wait(for: [expectation, fetchExpectation], timeout: 3)
    }
}
