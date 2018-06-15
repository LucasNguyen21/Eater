//
//  CustomerInfo.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 7/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation

class CustomerInfo {
    var name: String!
    var restaurantID: String?
    
    init(name: String, restaurantID: String) {
        self.name = name
        self.restaurantID = restaurantID
    }
}
