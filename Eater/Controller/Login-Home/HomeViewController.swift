//
//  HomeViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 11/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import GooglePlaces

class HomeViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var currentLocation: CLLocation!
    let locationHandler = LocationHandler()
    var locationString: String = ""
    let firebaseHandler = FirebaseHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        indicatorView.isHidden = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllow, error) in
        }
        startIndicator()
        getLocation()
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func startIndicator(){
        indicatorView.isHidden = false
        indicator.startAnimating()
    }
    
    func stopIndicator(){
        indicatorView.isHidden = true
        indicator.stopAnimating()
    }
    
    func getLocation(){
        locationHandler.requestAuthentication()
        locationHandler.getLocationAddress { (location) in
            if let street = location?.name {
                self.locationString.append(street)
                self.locationString.append(", ")
            }
            if let surburb = location?.locality {
                self.locationString.append(surburb)
            }
            self.updateLocationText()
            self.locationHandler.getCurrentLocationLatLong(completionHandler: { (currentLocation) in
                self.currentLocation = currentLocation
            })
        }
    }
    
    func updateLocationText() {
        locationTextField.text = locationString
        locationString = ""
        stopIndicator()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == findRestaurantSegue {
            let restaurantListViewController = segue.destination as! RestaurantListViewController
            restaurantListViewController.currentLoction = currentLocation
        }
    }

}

extension HomeViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.country = "au"
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension HomeViewController : GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var street_number = ""
        var route = ""
        var neighborhood = ""
        var locality = ""
        var administrative_area_level_1 = ""
        var country = ""
        var postal_code = ""
        var postal_code_suffix = ""
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    country = field.name
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
            locationTextField.text = street_number + " " + route + ", " + locality
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
