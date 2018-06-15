//
//  MapViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 8/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseAuth
import FirebaseFirestore

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var estimateView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderHistoryTable: UITableView!
    @IBOutlet weak var trackMapView: MKMapView!
    let locationManager = CLLocationManager()
    let firebaseHandler = FirebaseHandler()
    var restaurantList = [Restaurant]()
    var orderList = [Order]()
    var routeTimer = Timer()
    let sourAnnotation = DeliveryPointAnnotation()
    let destAnnotation = CustomerPointAnnotaion()
    override func viewDidLoad() {
        super.viewDidLoad()
        estimateView.isHidden = true
        firebaseHandler.getRestaurantList { (list) in
            self.restaurantList = list
            self.initialMap()
        }
        sourAnnotation.imageName = "car.png"
        destAnnotation.imageName = "CustomerAdd.png"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseHandler.getOrderHistoryList(customerEmail: (Auth.auth().currentUser?.email)!) { (orderHistoryList) in
            self.orderList = orderHistoryList
            self.orderHistoryTable.reloadData()
        }
    }
    
    func setRoute(orderRef: String, restaurantID: String){
        firebaseHandler.getLocationByOrderRef(orderRef: orderRef, restaurantID: restaurantID) { (location) in
            self.firebaseHandler.getCustomerLocationByOrderRef(orderRef: orderRef, restaurantID: restaurantID, completionHandler: { (customerLocation) in
                self.setRouteData(location: location, customerLocation: customerLocation)
            })
        }
    }
    
    
    
    func setRouteData(location: GeoPoint, customerLocation: GeoPoint){
        self.trackMapView.removeAnnotation(destAnnotation)
        self.trackMapView.removeAnnotation(sourAnnotation)
        
        let destCoordinate = CLLocationCoordinate2DMake(customerLocation.latitude, customerLocation.longitude)
        let sourCoordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        
        
        destAnnotation.coordinate = destCoordinate
        
        sourAnnotation.coordinate = sourCoordinate
        
        self.trackMapView.addAnnotation(destAnnotation)
        self.trackMapView.addAnnotation(sourAnnotation)
        
        let destPlaceMark = MKPlacemark(coordinate: destCoordinate)
        
        let sourPlaceMark = MKPlacemark(coordinate: sourCoordinate)
        
        let destItem = MKMapItem(placemark: destPlaceMark)
        let sourItem = MKMapItem(placemark: sourPlaceMark)
        
        let directRequest = MKDirectionsRequest()
        directRequest.source = sourItem
        directRequest.destination = destItem
        directRequest.transportType = .automobile
        
        let directions = MKDirections(request: directRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.estimateView.isHidden = false
            let route = response.routes[0]
            self.distanceLabel.text = "Distance: \(route.distance / 1000) km"
            let time = self.stringFromTimeInterval(interval: route.expectedTravelTime)
            self.timeLabel.text = "E.Time: " + time
            
            self.trackMapView.removeOverlays(self.trackMapView.overlays)
            self.trackMapView.add(route.polyline, level: .aboveRoads)
            let rekt = route.polyline.boundingMapRect
            self.trackMapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d s",hours,minutes,seconds)
    }
    
    func initialMap(){
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        trackMapView.delegate = self
        trackMapView.mapType = .standard
        trackMapView.isZoomEnabled = true
        trackMapView.isScrollEnabled = true
        trackMapView.showsCompass = true
        trackMapView.showsScale = true
        trackMapView.showsUserLocation = true
        
        for restaurant in restaurantList {
            let annotation = MKPointAnnotation()
            let location = CLLocationCoordinate2DMake(restaurant.latitude, restaurant.longitude)
            annotation.coordinate = location
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.surburb
            trackMapView.addAnnotation(annotation)
        }
        
    }
    
    @IBAction func overviewButtonAction(_ sender: UIButton) {
        routeTimer.invalidate()
        estimateView.isHidden = true
        self.trackMapView.removeOverlays(self.trackMapView.overlays)
        locationManager.startUpdatingLocation()
        orderHistoryTable.reloadData()
    }
    

}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegion(center: locValue, span: span)
        trackMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor(red: 30/255, green: 83/255, blue: 168/255, alpha: 1)
        render.lineWidth = 5.0
        return render
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var anView: MKAnnotationView?
        if annotation is DeliveryPointAnnotation {
            let deliveryID = "deliAnnotation"
            anView = mapView.dequeueReusableAnnotationView(withIdentifier: deliveryID)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: deliveryID)
                anView?.canShowCallout = true
            }
            else {
                anView?.annotation = annotation
            }
            
            if let cpa = annotation as? DeliveryPointAnnotation {
                anView?.image = UIImage(named: cpa.imageName)
            }
        } else if annotation is CustomerPointAnnotaion{
            let customerID = "custAnnotation"
            
            anView = mapView.dequeueReusableAnnotationView(withIdentifier: customerID)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: customerID)
                anView?.canShowCallout = true
            }
            else {
                anView?.annotation = annotation
            }
            if let cpa = annotation as? CustomerPointAnnotaion {
                anView?.image = UIImage(named: cpa.imageName)
            }
        } else {
            return nil
        }
        return anView
    }
}

extension MapViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mapCell, for: indexPath) as! MapTableViewCell
        cell.deliveryStatus.text = orderList[indexPath.row].status
        cell.restaurantName.text = orderList[indexPath.row].restaurantName
        cell.orderRef.text = "Order Ref: " + orderList[indexPath.row].orderRef
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.routeTimer.invalidate()
        self.setRoute(orderRef: self.orderList[indexPath.row].orderRef, restaurantID: self.orderList[indexPath.row].restaurantID)
        self.routeTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            self.setRoute(orderRef: self.orderList[indexPath.row].orderRef, restaurantID: self.orderList[indexPath.row].restaurantID)
        })
    }
}

