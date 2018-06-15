

//
//  CoreDataHandlerTests.swift
//  EaterUnitTests
//
//  Created by Nguyen Dinh Thang on 10/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import XCTest
@testable import Eater

class CoreDataHandlerTests: XCTestCase {
    var coredataHandler: CoreDataHandler!
    var order: [OrderRestaurant]!
    override func setUp() {
        super.setUp()
        coredataHandler = CoreDataHandler()
        order = [OrderRestaurant]()
        let restaurantID = "1"
        let restaurantName = "2"
        let owner = "3"
        let foodName = "4"
        let imagePath = "5"
        let price = "6"
        let qty = "6"
        coredataHandler.addFood(restaurantID: restaurantID, restaurantName: restaurantName, owner: owner, foodName: foodName, imagePath: imagePath, price: price, qty: qty) { (bool) in
            self.order = self.coredataHandler.loadOrderRestaurant()
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coredataHandler = nil
    }
    
    func testLoadOrderRestaurant(){
        let orderRestaurant = coredataHandler.loadOrderRestaurant()
        XCTAssertEqual(orderRestaurant.count, 1)
    }
    
    func testAddFood(){
        XCTAssertEqual(order.count, 1)
        XCTAssertEqual(order[0].restaurantID, "1")
        XCTAssertEqual(order[0].restaurantName, "2")
        XCTAssertEqual(order[0].owner, "3")
    }
    
    func testDeleteALlData(){
        coredataHandler.deleteAllData { (bool) in
            self.order = self.coredataHandler.loadOrderRestaurant()
            XCTAssertEqual(self.order.count, 0)
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
