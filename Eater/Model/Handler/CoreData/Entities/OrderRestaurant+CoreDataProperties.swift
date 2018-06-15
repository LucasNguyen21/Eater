//
//  OrderRestaurant+CoreDataProperties.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 22/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderRestaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderRestaurant> {
        return NSFetchRequest<OrderRestaurant>(entityName: "OrderRestaurant")
    }

    @NSManaged public var restaurantID: String?
    @NSManaged public var restaurantName: String?
    @NSManaged public var owner: String?
    @NSManaged public var orderFood: NSSet?

}

// MARK: Generated accessors for orderFood
extension OrderRestaurant {

    @objc(addOrderFoodObject:)
    @NSManaged public func addToOrderFood(_ value: OrderFood)

    @objc(removeOrderFoodObject:)
    @NSManaged public func removeFromOrderFood(_ value: OrderFood)

    @objc(addOrderFood:)
    @NSManaged public func addToOrderFood(_ values: NSSet)

    @objc(removeOrderFood:)
    @NSManaged public func removeFromOrderFood(_ values: NSSet)

}
