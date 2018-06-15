//
//  AddToCartViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class AddToCartViewController: UIViewController {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    var food: Food!
    var currentRestaurant: Restaurant!
    var coredataHandler = CoreDataHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        foodNameLabel.text = food.name
        totalLabel.text = "$ " + food.price
        qtyTextField.text = "1"
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func qtyStepper(_ sender: UIStepper) {
        
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        coredataHandler.addFood(restaurantID: currentRestaurant.id, restaurantName: currentRestaurant.name, owner: currentRestaurant.owner, foodName: food.name, imagePath: food.imagePath, price: food.price, qty: qtyTextField.text!) { (result) in
            self.showAlert(title: "Add To Cart", message: "Successfully")
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
