//
//  MapViewControllerTest.swift
//  EaterUnitTests
//
//  Created by Nguyen Dinh Thang on 10/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import XCTest
@testable import Eater

class MapViewControllerTest: XCTestCase {
    let viewController = MapViewController()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetRoute(){
        viewController.firebaseHandler.getCustomerLocationByOrderRef(orderRef: "123", restaurantID: "234") { (location) in
            XCTAssertNil(location)
        }
        
        viewController.firebaseHandler.getCustomerLocationByOrderRef(orderRef: "FegNqcscjaXE8BBQp6Sj", restaurantID: "0") { (location) in
            XCTAssertEqual(location.latitude, 1)
        }
    }
    
    func testStringFromTimeInterval(){
        let result = viewController.stringFromTimeInterval(interval: 500)
        XCTAssertEqual(result, "00:08:20 s")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
