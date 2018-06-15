//
//  EaterUITests.swift
//  EaterUITests
//
//  Created by Nguyen Dinh Thang on 9/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import XCTest

class EaterUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHomePage(){
        let app = XCUIApplication()
        app.tabBars.children(matching: .button).element(boundBy: 0).tap()
        app.staticTexts["Enter your full address"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element.tap()
        let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"more, numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        moreKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["232 Princes Highway"]/*[[".cells.staticTexts[\"232 Princes Highway\"]",".staticTexts[\"232 Princes Highway\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Find Restaurants"].tap()
    }
    
    func testRestaurantList(){
        let app = XCUIApplication()
        app.buttons["Find Restaurants"].tap()
        app.navigationBars["Restaurants"].otherElements["Restaurants"].tap()
        app.buttons["Search"].tap()
        app.buttons["All cuisines"].tap()
        app.buttons["Refine"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["23 Swanston Street, Melbourne"]/*[[".cells.staticTexts[\"23 Swanston Street, Melbourne\"]",".staticTexts[\"23 Swanston Street, Melbourne\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let restaurantsButton = app.navigationBars["Eater.RestaurantDetailView"].buttons["Restaurants"]
        restaurantsButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["123 dik"]/*[[".cells.staticTexts[\"123 dik\"]",".staticTexts[\"123 dik\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        restaurantsButton.tap()
        tablesQuery2/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"bun ngon")/*[[".cells.containing(.staticText, identifier:\"bun\")",".cells.containing(.staticText, identifier:\"123 dik\")",".cells.containing(.staticText, identifier:\"bun ngon\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 1).tap()
        restaurantsButton.tap()
        tablesQuery2/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"thabg")/*[[".cells.containing(.staticText, identifier:\"bunnn\")",".cells.containing(.staticText, identifier:\"23 Swanston Street, Melbourne\")",".cells.containing(.staticText, identifier:\"thabg\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).tap()
        restaurantsButton.tap()
    }
    
    func testRestaurantDetail(){
        
        let app = XCUIApplication()
        app.buttons["Find Restaurants"].tap()
        app.navigationBars["Restaurants"].otherElements["Restaurants"].tap()
        app.buttons["Search"].tap()
        app.buttons["All cuisines"].tap()
        app.buttons["Refine"].tap()
        app.staticTexts["2 Restaurants open now"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"bun ngon")/*[[".cells.containing(.staticText, identifier:\"bun\")",".cells.containing(.staticText, identifier:\"123 dik\")",".cells.containing(.staticText, identifier:\"bun ngon\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).tap()
        
        let restaurantsButton = app.navigationBars["Eater.RestaurantDetailView"].buttons["Restaurants"]
        restaurantsButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"thabg")/*[[".cells.containing(.staticText, identifier:\"bunnn\")",".cells.containing(.staticText, identifier:\"23 Swanston Street, Melbourne\")",".cells.containing(.staticText, identifier:\"thabg\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).tap()
        restaurantsButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["bun ngon"]/*[[".cells.staticTexts[\"bun ngon\"]",".staticTexts[\"bun ngon\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        restaurantsButton.tap()

    }
    
    func testMenu(){
        
        let app = XCUIApplication()
        app.buttons["Find Restaurants"].tap()
        app.navigationBars["Restaurants"].otherElements["Restaurants"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["123 dik"]/*[[".cells.staticTexts[\"123 dik\"]",".staticTexts[\"123 dik\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["bun ngon"].tap()
        app.staticTexts["123 dik"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        
        let menuButton = app.buttons["Menu"]
        menuButton.tap()
        app.buttons["Reviews"].tap()
        app.buttons["Info"].tap()
        menuButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["bun"]/*[[".cells.staticTexts[\"bun\"]",".staticTexts[\"bun\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let backButton = app.navigationBars["Eater.FoodView"].buttons["Back"]
        backButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["bsjsh"]/*[[".cells.staticTexts[\"bsjsh\"]",".staticTexts[\"bsjsh\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()

        
    }
    
    func testAddToCart(){
        
        let app = XCUIApplication()
        app.buttons["Find Restaurants"].tap()
        app.navigationBars["Restaurants"].otherElements["Restaurants"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["123 dik"]/*[[".cells.staticTexts[\"123 dik\"]",".staticTexts[\"123 dik\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["bun"]/*[[".cells.staticTexts[\"bun\"]",".staticTexts[\"bun\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.cells.children(matching: .button).element.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1)
        element.staticTexts["bun cha"].tap()
        app.staticTexts["Qty"].tap()
        app.staticTexts["Total"].tap()
        
        let element2 = element.children(matching: .other).element.children(matching: .other).element
        element2.tap()
        element2.tap()
        
        let steppersQuery = app.steppers
        steppersQuery.buttons["Increment"].tap()
        steppersQuery.buttons["Decrement"].tap()
        element2.children(matching: .textField).element.tap()
        element2.tap()
        app.buttons["Add To Cart"].tap()
        app.alerts["Add To Cart"].buttons["Ok"].tap()
        
    }
    
    func testReview(){
        
        
        let app = XCUIApplication()
        app.buttons["Find Restaurants"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["123 dik"]/*[[".cells.staticTexts[\"123 dik\"]",".staticTexts[\"123 dik\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Reviews"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["shotgun1712@gmail.com"]/*[[".cells.staticTexts[\"shotgun1712@gmail.com\"]",".staticTexts[\"shotgun1712@gmail.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let writeAReviewButton = app.buttons["Write a Review"]
        writeAReviewButton.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 3).tap()
        app.buttons["Submit"].tap()
        
    }
    
    func testInfo(){
        
        let app = XCUIApplication()
        app.buttons["Find Restaurants"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["123 dik"]/*[[".cells.staticTexts[\"123 dik\"]",".staticTexts[\"123 dik\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Info"].tap()
        app.staticTexts["Open Time:"].tap()
        app.staticTexts["In Construction"].tap()
        app.navigationBars["Eater.RestaurantDetailView"].buttons["Restaurants"].tap()
        
    }
}
