//
//  OrderListRestaurant.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 22/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation

class OrderListRestaurant {
    var orderID: String!
    var custName: String!
    var custPhone: String!
    var custAdd: String!
    var orderDesc: String!
    var status: String!
    var total: String!
    
    init(orderID: String, custName: String, custPhone: String, custAdd: String, orderDesc: String, status: String, total: String) {
        self.orderID = orderID
        self.custName = custName
        self.custPhone = custPhone
        self.custAdd = custAdd
        self.orderDesc = orderDesc
        self.status = status
        self.total = total
    }
}
