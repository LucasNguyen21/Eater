//
//  Order.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 18/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation

class Order {
    var status: String!
    var restaurantName: String!
    var restaurantID: String!
    var orderRef: String!
    
    
    init(orderRef: String, restaurantID: String, restaurantName: String, status: String) {
        self.orderRef = orderRef
        self.restaurantName = restaurantName
        self.restaurantID = restaurantID
        self.status = status
    }
}
