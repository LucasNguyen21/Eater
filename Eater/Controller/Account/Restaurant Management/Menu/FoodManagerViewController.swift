//
//  FoodManagerViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 27/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class FoodManagerViewController: UIViewController {

    @IBOutlet weak var foodManagerTableView: UITableView!
    @IBOutlet weak var totalFoodLabel: UILabel!
    
    var menuList = [Menu]()
    var firebaseHandler = FirebaseHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (rID) in
            self.firebaseHandler.getMenu(restaurantID: rID) { (menuList) in
                self.menuList = menuList
                self.updateTotalLabel()
                self.foodManagerTableView.reloadData()
                
            }
        }
        
        foodManagerTableView.delegate = self
        foodManagerTableView.dataSource = self
    }
    
    func updateTotalLabel(){
        var totalFood: Int = 0
        for i in menuList {
            totalFood = totalFood + i.food.count
        }
        if totalFood > 1 && menuList.count < 2 {
            self.totalFoodLabel.text = String(menuList.count) + " Menu, " + String(totalFood) + " Dishes"
        } else if totalFood > 1 && menuList.count > 1 {
            self.totalFoodLabel.text = String(menuList.count) + " Menus, " + String(totalFood) + " Dishes"
        } else {
            self.totalFoodLabel.text = String(menuList.count) + " Menu, " + String(totalFood) + " Dish"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateFoodSegue {
            let updateFoodVC = segue.destination as! AddFoodViewController
            if let selectedCell = sender as? UITableViewCell{
                let indexPath = foodManagerTableView.indexPath(for: selectedCell)!
                updateFoodVC.food = menuList[indexPath.section].food[indexPath.row]
                updateFoodVC.status = "Update"
                updateFoodVC.delegate = self
            }
        }
        if segue.identifier == addFoodSegue {
            let addFoodVC = segue.destination as! AddFoodViewController
            addFoodVC.delegate = self
        }
    }
}

extension FoodManagerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList[section].food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodManagerCell, for: indexPath) as! FoodManagerTableViewCell
        cell.foodNameLabel.text = menuList[indexPath.section].food[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuList[section].suicine
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
            header.textLabel?.textAlignment = NSTextAlignment.left
    }
}

extension FoodManagerViewController : AddFoodViewControllerDelegate {
    func reloadData() {
        firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
            self.firebaseHandler.getMenu(restaurantID: restaurantID) { (menuList) in
                self.menuList = menuList
                self.updateTotalLabel()
                self.foodManagerTableView.reloadData()
            }
        }
        
    }
    
    
}
