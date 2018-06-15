//
//  FoodViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
    @IBOutlet weak var foodTableView: UITableView!
    var currentRestaurant: Restaurant!
    var foodList = [Food]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodCellIdentifier, for: indexPath) as! FoodTableViewCell
        cell.setFood(food: foodList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension FoodViewController: FoodTableViewCellDelegate {
    func displayAddFood(food: Food) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addToCartViewController =  storyBoard.instantiateViewController(withIdentifier: addToCartSID) as! AddToCartViewController
        addToCartViewController.food = food
        addToCartViewController.currentRestaurant = currentRestaurant
        //addToCartViewController.delegate = self
        self.present(addToCartViewController, animated: true, completion: nil)
    }

    
}
