//
//  CoreDataHandler.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 22/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHandler {
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func loadOrderRestaurant() -> [OrderRestaurant]{
        let fetchRequest = NSFetchRequest<OrderRestaurant>(entityName: "OrderRestaurant")
        var restaurantList = [OrderRestaurant]()
        do {
            restaurantList = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return restaurantList
    }
    
    func addFood(restaurantID: String, restaurantName: String, owner: String, foodName: String, imagePath: String, price: String, qty: String, completionHandler: @escaping(_ result: Bool) -> Void){
        var hasRestaurant: Bool = false
        var currentRestaurant: OrderRestaurant?
        let restaurantList = loadOrderRestaurant()
        for restaurant in restaurantList {
            if restaurant.restaurantID == restaurantID {
                hasRestaurant = true
                currentRestaurant = restaurant
                break
            }
        }
        
        if hasRestaurant == false {
            let restaurant = NSEntityDescription.insertNewObject(forEntityName: "OrderRestaurant", into: self.managedObjectContext) as? OrderRestaurant
            restaurant?.restaurantID = restaurantID
            restaurant?.restaurantName = restaurantName
            restaurant?.owner = owner
            currentRestaurant = restaurant
            saveContext()
        }

        let currentFood = OrderFood(entity: OrderFood.entity(), insertInto: self.managedObjectContext)
        currentFood.name =  foodName
        currentFood.imagePath = imagePath
        currentFood.price = price
        currentFood.qty = qty
        currentRestaurant?.addToOrderFood(currentFood)
        saveContext()
        completionHandler(true)
    }
    
    func deleteAllData(completionHandler: @escaping(_ result: Bool) -> Void){
        let restaurantList = loadOrderRestaurant()
        for restaurant in 0 ..< restaurantList.count {
            self.managedObjectContext.delete(restaurantList[restaurant])
            saveContext()
            if restaurant == restaurantList.count - 1 {
                completionHandler(true)
            }
        }
    
    }
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
}
