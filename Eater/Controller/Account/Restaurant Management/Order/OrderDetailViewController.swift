//
//  OrderDetailViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 23/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol OrderDetailViewControllerDelegate {
    func reloadTable()
}

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var orderRefLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerPhoneLabel: UILabel!
    @IBOutlet weak var customerAddressLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    
    var orderDetail: OrderListRestaurant!
    let firebaseHandler = FirebaseHandler()
    var status: String = "Pending"
    var delegate: OrderDetailViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        orderRefLabel.text = "Order Ref: " + orderDetail.orderID
        customerNameLabel.text = "Name: " + orderDetail.custName
        customerPhoneLabel.text = "Phone No: " + orderDetail.custPhone
        customerAddressLabel.text = "Address: " + orderDetail.custAdd
        descLabel.text = "Order Details: \n" + orderDetail.orderDesc
        totalLabel.text = "Total: $" + orderDetail.total
        if orderDetail.status == "Pending" {
            statusSegmentControl.selectedSegmentIndex = 0
        } else {
            statusSegmentControl.selectedSegmentIndex = 1
        }
    }

    @IBAction func statusSegmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            status = "Pending"
        } else {
            status = "Approved"
        }
    }
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
            self.firebaseHandler.setApprovedOrderStatus(orderRef: self.orderDetail.orderID, restaurantID: restaurantID, status: self.status) { (bool) in
                self.delegate?.reloadTable()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
