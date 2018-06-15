//
//  RestaurantListViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 13/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantListViewController: UIViewController {
    @IBOutlet weak var restaurantListTableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var restaurantQtyLabel: UILabel!
    var firebaseHandler: FirebaseHandler!
    var locationHandler = LocationHandler()
    var restaurantList = [Restaurant]()
    var currentLoction: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-------Restaurant View Controller--------")
        print(currentLoction.coordinate.latitude)
        print(currentLoction.coordinate.longitude)
        startIndicator()
        restaurantListTableView.delegate = self
        restaurantListTableView.dataSource = self
        firebaseHandler = FirebaseHandler()
        firebaseHandler.getRestaurantList { (restaurants) in
            self.restaurantList = restaurants
            if restaurants.count > 0 {
                if restaurants.count == 1 {
                    self.restaurantQtyLabel.text = String(restaurants.count) + " Restaurant open now"
                } else {
                    self.restaurantQtyLabel.text = String(restaurants.count) + " Restaurants open now"
                }
                
            } else {
                self.restaurantQtyLabel.text = "No restaurant nearby"
            }
            
            self.restaurantListTableView.reloadData()
            self.stopIndicator()
        }
    }
    
    func filterRestaurantByLocation(lat: CLLocationDegrees, long: CLLocationDegrees){
        
    }
    
    func startIndicator(){
        restaurantListTableView.isHidden = true
        indicatorView.isHidden = false
        indicator.startAnimating()
    }
    
    func stopIndicator(){
        restaurantListTableView.isHidden = false
        indicatorView.isHidden = true
        indicator.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == restaurantToDetailViewSegue {
            let restaurantDetailViewController = segue.destination as! RestaurantDetailViewController
            if let selectedCell = sender as? UITableViewCell{
                let indexPath = restaurantListTableView.indexPath(for: selectedCell)!
                restaurantDetailViewController.restaurant = restaurantList[indexPath.row]
            }
        }
    }
    
    @IBAction func refineButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
    
    }
    
    @IBAction func allCuisineButtonAction(_ sender: UIButton) {
    
    }
    
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantListCellID, for: indexPath) as! RestaurantListTableViewCell
        cell.setRestaurant(restaurant: restaurantList[indexPath.row])
        return cell
    }
    
}
