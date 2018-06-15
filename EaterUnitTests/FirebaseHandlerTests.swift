//
//  FirebaseHandlerTests.swift
//  EaterUnitTests
//
//  Created by Nguyen Dinh Thang on 10/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import XCTest
import Firebase
@testable import Eater

class FirebaseHandlerTests: XCTestCase {
    let firebaseHandler = FirebaseHandler()
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testGetRestaurantID(){
        let expectation = self.expectation(description: "GetRID")
        firebaseHandler.getRestaurantId(customerEmail: "llsogekingll@gmail.com") { (id) in
            XCTAssertEqual(id, "1")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCountNumberOfRestaurants(){
        let expectation = self.expectation(description: "Number")
        firebaseHandler.countNumberOfRestaurants { (number) in
            XCTAssertNotNil(number)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSetApprovedOrderStatus(){
        let expectation = self.expectation(description: "Approved")
        firebaseHandler.setApprovedOrderStatus(orderRef: "1", restaurantID: "1", status: "Approve") { (bool) in
            XCTAssertTrue(bool)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetOrderHistoryList(){
        let expectation = self.expectation(description: "test")
        firebaseHandler.getOrderHistoryList(customerEmail: "llsogekingll@gmail.com") { (orderlist) in
            XCTAssertNotNil(orderlist)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
