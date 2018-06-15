//
//  OrderFood+CoreDataProperties.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 22/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderFood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderFood> {
        return NSFetchRequest<OrderFood>(entityName: "OrderFood")
    }

    @NSManaged public var name: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var price: String?
    @NSManaged public var qty: String?
    @NSManaged public var orderRestaurant: OrderRestaurant?

}
