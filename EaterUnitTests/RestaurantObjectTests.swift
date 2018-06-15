//
//  RestaurantObjectTests.swift
//  EaterUnitTests
//
//  Created by Nguyen Dinh Thang on 10/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import XCTest
@testable import Eater

class RestaurantObjectTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit(){
        let id = "0"
        let name = "thang"
        let logo = "1"
        let owner = "2"
        let surburb = "3"
        let latitude = 0.1
        let longitude = 0.2
        let cuisine = "4"
        let rating = "5"
        let menu = Menu(suicine: "123", food: [Food(name: "", imagePath: "", price: "", description: "", cuisine: "", imageName: "")])
        let restaurant = Restaurant(id: id, name: name, logo: logo, cuisine: cuisine, owner: owner, rating: rating, surburb: surburb, latitude: latitude, longitude: longitude, menu: [menu])
        XCTAssertEqual(restaurant.id, id)
        XCTAssertEqual(restaurant.name, name)
        XCTAssertEqual(restaurant.logo, logo)
        XCTAssertEqual(restaurant.cuisine, cuisine)
        XCTAssertEqual(restaurant.owner, owner)
        XCTAssertEqual(restaurant.rating, rating)
        XCTAssertEqual(restaurant.surburb, surburb)
        XCTAssertEqual(restaurant.latitude, latitude)
        XCTAssertEqual(restaurant.longitude, longitude)
        XCTAssertNotNil(restaurant.menu, "menu not nil")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
