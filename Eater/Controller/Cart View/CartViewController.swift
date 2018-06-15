//
//  CartViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 18/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    
    var coredataHandler = CoreDataHandler()
    let firebaseHandler = FirebaseHandler()
    var orderRestaurantList = [OrderRestaurant]()
    var subTotalPrice: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orderRestaurantList = coredataHandler.loadOrderRestaurant()
        cartTableView.reloadData()
        subTotalPrice = 0.0
    }
    
    @IBAction func checkOutButtonAction(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let checkOutViewController =  storyBoard.instantiateViewController(withIdentifier: checkOutViewSID) as! CheckOutViewController
        checkOutViewController.orderRestaurantList = orderRestaurantList
        checkOutViewController.delegate = self
        self.present(checkOutViewController, animated: true, completion: nil)
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderRestaurantList.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == orderRestaurantList.count {
            return 1
        } else {
            return (orderRestaurantList[section].orderFood?.allObjects.count)!
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == orderRestaurantList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: priceCellID, for: indexPath) as! PriceTableViewCell
            cell.totalPriceLabel.text = "$" + String(format: "%.2f", subTotalPrice)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: orderTableViewCellIdentifier, for: indexPath) as! OrderTableViewCell
            let foodArray: [OrderFood] = orderRestaurantList[indexPath.section].orderFood?.allObjects as! [OrderFood]
            cell.foodNameLabel.text = foodArray[indexPath.row].name
            cell.qty.text = "x " + foodArray[indexPath.row].qty!
            firebaseHandler.downloadImage(urlString: foodArray[indexPath.row].imagePath!, imageView: cell.foodImage) { (image) in
                cell.foodImage.image = image
            }
            let totalPrice = Double(foodArray[indexPath.row].qty!)! * Double(foodArray[indexPath.row].price!)!
            subTotalPrice = subTotalPrice + totalPrice
            cell.totalPriceLabel.text = "$" + String(format: "%.2f", totalPrice)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == orderRestaurantList.count {
            return "Total"
        } else {
            return orderRestaurantList[section].restaurantName
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == orderRestaurantList.count {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
            header.textLabel?.textAlignment = NSTextAlignment.right
        } else {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
            header.textLabel?.textAlignment = NSTextAlignment.left
        }
    }
}

extension CartViewController : CheckOutViewControllerDelegate {
    func reloadCartView() {
        orderRestaurantList = coredataHandler.loadOrderRestaurant()
        cartTableView.reloadData()
        subTotalPrice = 0.0
    }
}
