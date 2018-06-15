//
//  FirebaseHandler.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import AlamofireImage
import Alamofire
import UserNotifications
import FirebaseAuth
let imageCache = AutoPurgingImageCache()

class FirebaseHandler: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Test Foreground: \(notification.request.identifier)")
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("trasdk")
    }
    
    func orderListener(restaurantID: String, orderRef: String){
        let defaultStore = Firestore.firestore()
        UNUserNotificationCenter.current().delegate = self
        let listenOption = DocumentListenOptions()
        listenOption.includeMetadataChanges(true)
        defaultStore.collection("Restaurant").document(restaurantID).collection("Order").document(orderRef).addSnapshotListener(options: listenOption) { (snapshot, error) in
            self.loadNotification(title: "Order", body: "Order is on the way", identifier: "orderOnWay")
        }
        
    }
    
    func RestaurantOrderListener(restaurantID: String){
        let defaultStore = Firestore.firestore()
        UNUserNotificationCenter.current().delegate = self
        defaultStore.collection("Restaurant").document(restaurantID).collection("Order").addSnapshotListener { (snapShot, error) in
            if let snapshot = snapShot {
                snapshot.documentChanges.forEach({ (diff) in
                    if diff.type == .added {
                        print("ADD ORDER")
                        self.loadNotification(title: "Order", body: "Received New Order", identifier: "newOrder")
                    }
                    if diff.type == .removed {
                        print("REMOVE")
                    }
                    if diff.type == .modified {
                        self.loadNotification(title: "Order", body: "Your Order is prepared", identifier: "approvedOrder")
                        
                    }
                })
            } else {
                print("query snapshot fail")
            }
        }
    }
    
    private func loadNotification(title: String, body: String, identifier: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request) { (error) in
        }
        print("Modified")
    }
    
    func setRestaurant(id: String, logo: UIImage,cuisine: String, name: String, ownerEmail: String, address: String,location: GeoPoint, completionHandler: @escaping(_ bool: Bool)-> Void){
        let defaultStore = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        let date = UInt(Date().timeIntervalSince1970)
        let data = UIImageJPEGRepresentation(logo, 0.8)!
        
        let imageRef = storageRef.child("\(ownerEmail)/\(date).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        imageRef.putData(data, metadata: metaData) { (storageMetaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if let stoMetaData = storageMetaData {
                    let downloadURL = stoMetaData.downloadURL()!.absoluteString
                    defaultStore.collection("Restaurant").document(id).setData([
                        "Name" : name,
                        "Owner" : ownerEmail,
                        "Cuisine" : cuisine,
                        "Logo" : downloadURL,
                        "Surburb" : address,
                        "Location" : location,
                        "Rating" : "0"
                        ], completion: { (error) in
                            defaultStore.collection("CustomerInfo").document(ownerEmail).setData(["RestaurantID" : id], options: SetOptions.merge(), completion: { (error) in
                                completionHandler(true)
                            })
                    })
                }
            }
        }
        
    }
    
    ///retrun
    //ted
    func getRestaurantId(customerEmail: String, completionHandler: @escaping (_ restaurantID: String) -> Void){
        
        let defaultStore = Firestore.firestore()
        let docRef = defaultStore.collection("CustomerInfo").document(customerEmail)
        
        docRef.getDocument { (Snapshot, error) in
            if let snapshot = Snapshot {
                let array = snapshot.data() as NSDictionary
                var restaurantID: String = ""

                if array.object(forKey: "RestaurantID") != nil {
                    restaurantID = array.object(forKey: "RestaurantID") as! String
                } else {
                    restaurantID = "nil"
                }
                completionHandler(restaurantID)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getLocationByOrderRef(orderRef: String, restaurantID: String, completionHandler: @escaping(_ location: GeoPoint) -> Void){
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").document(restaurantID).collection("Order").document(orderRef).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                let data = snapshot.data() as NSDictionary
                let location = data.value(forKey: "Location") as! GeoPoint
                completionHandler(location)
            }
        }
    }
    
    func getCustomerLocationByOrderRef(orderRef: String, restaurantID: String, completionHandler: @escaping(_ location: GeoPoint) -> Void){
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").document(restaurantID).collection("Order").document(orderRef).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                let data = snapshot.data() as NSDictionary
                let location = data.value(forKey: "CustomerLocation") as! GeoPoint
                completionHandler(location)
            }
        }
    }
    
    func getRestaurantLocationByID(restaurantID: String, completionHandler: @escaping (_ location: GeoPoint) -> Void){
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").document(restaurantID).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                let data = snapshot.data() as NSDictionary
                let location = data.value(forKey: "Location") as! GeoPoint
                completionHandler(location)
            }
        }
    }
    
    func countNumberOfRestaurants(completionHandler: @escaping (_ numberOfRestaurant: String) -> Void){
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").getDocuments { (Snapshots, error) in
            if let snapshots = Snapshots {
                let numberOfRestaurant = snapshots.count
                completionHandler(String(numberOfRestaurant))
            }
        }
        
    }

    
    func setApprovedOrderStatus(orderRef: String, restaurantID: String, status: String, completionHandler: @escaping(_ bool: Bool) -> Void){
        let defaultStore = Firestore.firestore()
        let docRef = defaultStore.collection("Restaurant").document(restaurantID).collection("Order").document(orderRef)
        docRef.setData(["Status" : status], options: SetOptions.merge()) { (error) in
            completionHandler(true)
        }
    }
    
    
    
    func setCustomerInfo(email: String, name: String, completionHandler: @escaping(_ bool: Bool) -> Void){
        let defaultStore = Firestore.firestore()
        let docRef = defaultStore.collection("CustomerInfo").document(email)
        docRef.setData(["Name" : name, "RestaurantID" : ""]) { (error) in
            completionHandler(true)
        }
    }
    
    func getCustomerInfo(customerEmail: String, completionHandler: @escaping (_ customerInfo: CustomerInfo) -> Void){
        let defaultStore = Firestore.firestore()
        let docRef = defaultStore.collection("CustomerInfo").document(customerEmail)
        
        docRef.getDocument { (Snapshot, error) in
            if let snapshot = Snapshot {
                if snapshot.exists == true {
                    let array = snapshot.data() as NSDictionary
                        var name: String = ""
                        var restaurantID: String = ""
                        
                        if array.object(forKey: "Name") != nil {
                            name = array.object(forKey: "Name") as! String
                        }
                        if array.object(forKey: "RestaurantID") != nil {
                            restaurantID = array.object(forKey: "RestaurantID") as! String
                        }
                        
                        print(restaurantID)
                        let customer = CustomerInfo(name: name, restaurantID: restaurantID)
                        completionHandler(customer)
                    
                } else {
                    let customer = CustomerInfo(name: "", restaurantID: "")
                    completionHandler(customer)
                }
            } else {
                let customer = CustomerInfo(name: "", restaurantID: "")
                completionHandler(customer)
                print("Document does not exist")
            }
        }
    }
    
    func getRestaurantList(completionHandler: @escaping (_ restaurants: [Restaurant]) -> Void){
        var restaurants = [Restaurant]()
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").getDocuments { (Snapshots, error) in
            if let snapshots = Snapshots {
                for snapshot in snapshots.documents {
                    let array = snapshot.data() as NSDictionary
                    let name = array.value(forKey: "Name") as! String
                    let owner = array.value(forKey: "Owner") as! String
                    let logo = array.value(forKey: "Logo") as! String
                    let surburb = array.value(forKey: "Surburb") as! String
                    let location = array.value(forKey: "Location") as! GeoPoint
                    let cuisine = array.value(forKey: "Cuisine") as! String
                    let rating = array.value(forKey: "Rating") as! String
                    
                    self.getReview(restaurantID: snapshot.documentID, completionHandler: { (ratingList) in
                        var totalRating: Int = 0
                        for i in 0 ..< ratingList.count {
                            totalRating = totalRating + Int(ratingList[i].rating)!
                            if i == ratingList.count - 1 {
                                totalRating = totalRating / (i+1)
                            }
                        }
                        self.getMenu(restaurantID: snapshot.documentID, completionHandler: { (menu) in
                            restaurants.append(Restaurant(id: snapshot.documentID,name: name, logo: logo, cuisine: cuisine, owner: owner, rating: String(totalRating), surburb: surburb, latitude: location.latitude, longitude: location.longitude, menu: menu))
                            completionHandler(restaurants)
                        })
                    })
                    
                    
                }
                
            }
        }
    }
    
    func getMenu(restaurantID: String, completionHandler: @escaping (_ menu: [Menu]) -> Void){
        var menuList = [Menu]()
        let defaultStore = Firestore.firestore()
        //let storageRef = Storage.storage()
        defaultStore.collection("Restaurant").document(restaurantID).collection("Menu").getDocuments { (Snapshots, error) in
            if let snapshots = Snapshots {
                for snapshot in snapshots.documents {
                    let data = snapshot.data() as NSDictionary
                    let image = data.value(forKey: "Image") as! String
                    let price = data.value(forKey: "Price") as! String
                    let suicine = data.value(forKey: "Suicine") as! String
                    let description = data.value(forKey: "Description") as! String
                    let imageName = data.value(forKey: "ImageName") as! String
                    
                    let food = Food(name: snapshot.documentID, imagePath: image, price: price, description: description, cuisine: suicine, imageName: imageName)
                    if menuList.contains(where: { (menu) -> Bool in
                        menu.suicine == suicine
                    }) {
                        for menu in menuList {
                            if menu.suicine == suicine {
                                menu.food.append(food)
                            }
                        }
                    } else {
                        menuList.append(Menu(suicine: suicine, food: [food]))
                    }
                    
                }
                completionHandler(menuList)
            }
        }
    }
    
    func deleteFood(restaurantID: String, foodName: String, imageName: String, completionHandler: @escaping(_ result: Bool) -> Void){
        let defaultStore = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        storageRef.child("\((Auth.auth().currentUser?.email)!)/\(imageName).jpg").delete { (error) in
            defaultStore.collection("Restaurant").document(restaurantID).collection("Menu").document(foodName).delete { (error) in
                completionHandler(true)
            }
        }
    }
    
    func setFood(restaurantID: String, foodName: String, image: UIImage, price: String, suicine: String, description: String, completionHandler: @escaping (_ bool: Bool) -> Void){
        let defaultStore = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        let date = UInt(Date().timeIntervalSince1970)
        let data = UIImageJPEGRepresentation(image, 0.8)!
        
        let imageRef = storageRef.child("\((Auth.auth().currentUser?.email)!)/\(date).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        imageRef.putData(data, metadata: metaData) { (storageMetaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if let stoMetaData = storageMetaData {
                    let downloadURL = stoMetaData.downloadURL()!.absoluteString
                    defaultStore.collection("Restaurant").document(restaurantID).collection("Menu").document(foodName).setData([
                        "Image" : downloadURL,
                        "Price" : price,
                        "Suicine" : suicine,
                        "Description" : description,
                        "ImageName" : ("\(date)")
                        ])
                    completionHandler(true)
                }
            }
        }
    }
    
    
    func setOrder(restaurantID: String, custName: String, custPhone: String, custAddress: String, orderItem: [OrderFood], totalPrice: String, deliveryLocation: GeoPoint, customerLocation: GeoPoint, completionHandler: @escaping (_ orderReference: String) -> Void){
        var orderDescription: String = ""
        for item in orderItem {
            orderDescription.append(item.qty!)
            orderDescription.append(" ")
            orderDescription.append(item.name!)
            orderDescription.append("\n")
        }
        
        let defaultStore = Firestore.firestore().collection("Restaurant").document(restaurantID).collection("Order").document()
        defaultStore.setData([
            "Status" : "Pending",
            "CustomerName" : custName,
            "CustomerPhone" : custPhone,
            "CustomerAddress" : custAddress,
            "OrderDescription" : orderDescription,
            "Total" : totalPrice,
            "Location" : deliveryLocation,
            "CustomerLocation" : customerLocation
        ]){ (error) in
            completionHandler(defaultStore.documentID)
        }
    }
    
    func setHistoryOrder(customerEmail: String,orderRef: String, restaurantID: String, restaurantName: String){
        let defaultStore = Firestore.firestore()
        defaultStore.collection("CustomerInfo").document(customerEmail).collection("Order").document(orderRef).setData([
            "Status" : "Delivering",
            "RestaurantName" : restaurantName,
            "RestaurantID" : restaurantID
        ]) { (error) in
            
        }
    }
    
    func getOrderHistoryList(customerEmail: String, completionHandler: @escaping (_ orderHistoryList: [Order])->Void){
        var orderHistoryList = [Order]()
        let defaultStore = Firestore.firestore()
        defaultStore.collection("CustomerInfo").document(customerEmail).collection("Order").getDocuments { (snapshots, error) in
            if let snapshots = snapshots {
                for snapshot in snapshots.documents {
                    let data = snapshot.data() as NSDictionary
                    let orderRef = snapshot.documentID
                    let restaurantID = data.value(forKey: "RestaurantID") as! String
                    let restaurantName = data.value(forKey: "RestaurantName") as! String
                    let status = data.value(forKey: "Status") as! String
                    orderHistoryList.append(Order(orderRef: orderRef, restaurantID: restaurantID, restaurantName: restaurantName, status: status))
                }
                completionHandler(orderHistoryList)
            }
        }
    }
    
    func getOrderList(restaurantID: String, completionHandler: @escaping (_ orderList: [OrderListRestaurant]) -> Void){
        var orderListRestaurant = [OrderListRestaurant]()
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").document(restaurantID).collection("Order").getDocuments { (Snapshots, error) in
            if let snapshots = Snapshots {
                for snapshot in snapshots.documents {
                    let data = snapshot.data() as NSDictionary
                    let custAdd = data.value(forKey: "CustomerAddress") as! String
                    let custName = data.value(forKey: "CustomerName") as! String
                    let custPhone = data.value(forKey: "CustomerPhone") as! String
                    let orderDesc = data.value(forKey: "OrderDescription") as! String
                    let status = data.value(forKey: "Status") as! String
                    let total = data.value(forKey: "Total") as! String
                    
                    orderListRestaurant.append(OrderListRestaurant(orderID: snapshot.documentID, custName: custName, custPhone: custPhone, custAdd: custAdd, orderDesc: orderDesc, status: status, total: total))
                }
                completionHandler(orderListRestaurant)
            }
        }
    }
    
    func setReview(customerEmail: String, rating: String, restaurantID: String, completionHandler: @escaping(_ bool: Bool) -> Void){
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").document(restaurantID).collection("Review").document(customerEmail).setData([
            "Rating" : rating,
            "Email" : customerEmail
        ]) { (error) in
            completionHandler(true)
        }
    }
    
    func getReview(restaurantID: String, completionHandler: @escaping (_ ratingList: [RatingObject]) -> Void){
        var ratingList = [RatingObject]()
        let defaultStore = Firestore.firestore()
        defaultStore.collection("Restaurant").document(restaurantID).collection("Review").getDocuments { (snapShots, error) in
            if let snapShots = snapShots {
                for snapshot in snapShots.documents {
                    let data = snapshot.data() as NSDictionary
                    let rating: String = data.value(forKey: "Rating") as! String
                    let customerEmail: String = data.value(forKey: "Email") as! String
                    ratingList.append(RatingObject(rating: rating, email: customerEmail))
                }
                completionHandler(ratingList)
            }
        }
    }
    
    func downloadImage(urlString: String, imageView: UIImageView, completionHandler: @escaping(_ image: UIImage) -> Void){
        let storageRef = Storage.storage()
        storageRef.reference(forURL: urlString).downloadURL { (url, error) in
            if error != nil {
                print("errr?")
            }
            else {
                if let cachedImage = imageCache.image(withIdentifier: urlString) {
                    completionHandler(cachedImage)
                } else {
                    if let _url = url {
                        Alamofire.request(_url).responseImage { (response) in
                            if let imageData = response.data {
                                let image = UIImage(data: imageData)
                                let size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
                                let scaledImage = image?.af_imageAspectScaled(toFill: size)
                                let circularImage = scaledImage?.af_imageRoundedIntoCircle()
                                imageCache.add(circularImage!, withIdentifier: urlString)
                                completionHandler(circularImage!)
                            }
                        }
                    }
                }
                
            }
            
        }
    }
        
}
