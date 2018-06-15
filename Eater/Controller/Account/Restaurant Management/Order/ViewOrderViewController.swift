//
//  ViewOrderViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 22/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewOrderViewController: UIViewController, OrderDetailViewControllerDelegate {

    @IBOutlet weak var orderQty: UILabel!
    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    

    @IBOutlet weak var orderListTableView: UITableView!
    var firebaseHandler = FirebaseHandler()
    var orderListRestaurant = [OrderListRestaurant]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
            self.firebaseHandler.getOrderList(restaurantID: restaurantID) { (orderList) in
                self.orderListRestaurant = orderList
                self.orderQty.text = String(self.orderListRestaurant.count) + " Orders"
                self.sortList(status: "Pending")
                self.orderListTableView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == orderDetailSegue {
            let detailViewController = segue.destination as! OrderDetailViewController
            if let selectedCell = sender as? UITableViewCell{
                let indexPath = orderListTableView.indexPath(for: selectedCell)!
                detailViewController.orderDetail = orderListRestaurant[indexPath.row]
                detailViewController.delegate = self
            }
        }
    }
    
    func reloadTable() {
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
            self.firebaseHandler.getOrderList(restaurantID: restaurantID) { (orderList) in
                self.orderListRestaurant = orderList
                self.sortList(status: "Pending")
                self.orderListTableView.reloadData()
            }
        }
        
    }
    
    func sortList(status: String){
        let newList = orderListRestaurant.filter { (restaurant) -> Bool in
            restaurant.status.contains(status)
        }
        orderListRestaurant = newList
        self.orderQty.text = String(self.orderListRestaurant.count) + " Orders"
        orderListTableView.reloadData()
    }
    
    @IBAction func pendingButtonAction(_ sender: UIButton) {
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
            self.firebaseHandler.getOrderList(restaurantID: restaurantID) { (orderList) in
                self.orderListRestaurant = orderList
                self.sortList(status: "Pending")
            }
        }
        
        
    }
    @IBAction func approvedButtonAction(_ sender: UIButton) {
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
            self.firebaseHandler.getOrderList(restaurantID: restaurantID) { (orderList) in
                self.orderListRestaurant = orderList
                self.sortList(status: "Approved")
            }
        }
        
        
    }
    
}

extension ViewOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListRestaurant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewOrderCellID, for: indexPath) as! ViewOrderTableViewCell
        cell.orderRefLabel.text = "Order Ref: " + orderListRestaurant[indexPath.row].orderID
        cell.orderStatusLabel.text = "Status: " + orderListRestaurant[indexPath.row].status
        return cell
    }
    
    
}
