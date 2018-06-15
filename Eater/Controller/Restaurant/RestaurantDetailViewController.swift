//
//  RestaurantDetailViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 15/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import STRatingControl

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet weak var animatingViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var infoButotn: UIButton!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingControl: STRatingControl!
    
    var restaurant: Restaurant!
    var ratingList = [RatingObject]()
    let firebaseHandler = FirebaseHandler()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        initialReviewTable()
        initialMap()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
    }
    
    func initialReviewTable(){
        firebaseHandler.getReview(restaurantID: restaurant.id) { (ratingList) in
            self.ratingList = ratingList
            self.reviewTableView.reloadData()
        }
    }
    
    func initialMap(){
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2DMake(restaurant.latitude, restaurant.longitude)
        annotation.coordinate = location
        annotation.title = restaurant.name
        annotation.subtitle = restaurant.surburb
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setUpView(){
        restaurantNameLabel.text = restaurant.name
        firebaseHandler.downloadImage(urlString: restaurant.logo, imageView: restaurantImageView) { (image) in
            self.restaurantImageView.image = image
        }
        locationLabel.text = restaurant.surburb
        ratingControl.rating = Int(restaurant.rating)!
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == menuToFoodViewSegue {
            let foodViewController = segue.destination as! FoodViewController
            if let selectedCell = sender as? UITableViewCell{
                let indexPath = menuTableView.indexPath(for: selectedCell)!
                foodViewController.foodList = restaurant.menu[indexPath.row].food
                foodViewController.currentRestaurant = restaurant
            }
        }
    }
    
    @IBAction func menuActionButton(_ sender: UIButton) {
        changeButtonFontSize(changeButton: sender, normalButton1: reviewButton, normalButton2: infoButotn)
        animateView(animatingViewConstant: 0, viewContainerConstant: 0)
    }
    @IBAction func reviewActionButton(_ sender: UIButton) {
        changeButtonFontSize(changeButton: sender, normalButton1: menuButton, normalButton2: infoButotn)
        animateView(animatingViewConstant: self.view.bounds.width / 3, viewContainerConstant: -(self.view.bounds.width))
    }
    @IBAction func infoActionButton(_ sender: UIButton) {
        changeButtonFontSize(changeButton: sender, normalButton1: menuButton, normalButton2: reviewButton)
        animateView(animatingViewConstant: self.view.bounds.width / 3 * 2, viewContainerConstant: -(self.view.bounds.width * 2))
    }
    @IBAction func writeReviewButtonAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let makeRatingViewController =  storyBoard.instantiateViewController(withIdentifier: makeRatingViewControllerSID) as! MakeRatingViewController
        makeRatingViewController.restaurant = restaurant
        makeRatingViewController.delegate = self
        self.present(makeRatingViewController, animated: true, completion: nil)
    }
    
    func changeButtonFontSize(changeButton : UIButton, normalButton1: UIButton, normalButton2: UIButton){
        changeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        normalButton1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        normalButton2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func animateView(animatingViewConstant: CGFloat, viewContainerConstant: CGFloat){
        self.viewContainer.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.viewContainerLeadingConstraint.constant = viewContainerConstant
            self.view.layoutIfNeeded()
        }) { (bool) in
            self.viewContainer.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.animatingViewLeadingConstraint.constant = animatingViewConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension RestaurantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return restaurant.menu.count
        } else {
            return ratingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: menuTableViewCellIdentifier, for: indexPath) as! MenuTableViewCell
            cell.suicineName.text = restaurant.menu[indexPath.row].suicine
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reviewTableViewCellIdentifier, for: indexPath) as! ReviewTableViewCell
            cell.customerName.text = ratingList[indexPath.row].email
            cell.ratingControl.rating = Int(ratingList[indexPath.row].rating)!
            return cell
        }
    }
}

extension RestaurantDetailViewController : MakeRatingViewControllerDelegate {
    func reloadData() {
        initialReviewTable()
    }
}
