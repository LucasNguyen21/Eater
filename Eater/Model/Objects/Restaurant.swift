//
//  Restaurant.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation

class Restaurant {
    var id: String!
    var name: String!
    var logo: String!
    var owner: String!
    var surburb: String!
    var latitude: Double!
    var longitude: Double!
    var cuisine: String!
    var rating: String!
    var menu: [Menu]!
    
    init(id: String, name: String, logo: String, cuisine: String, owner: String, rating: String, surburb: String!, latitude: Double, longitude: Double, menu: [Menu]) {
        self.id = id
        self.name = name
        self.logo = logo
        self.owner = owner
        self.menu = menu
        self.surburb = surburb
        self.latitude = latitude
        self.longitude = longitude
        self.cuisine = cuisine
        self.rating = rating
    }
}
