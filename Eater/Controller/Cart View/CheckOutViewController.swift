//
//  CheckOutViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 22/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import GooglePlaces
import FirebaseFirestore

protocol CheckOutViewControllerDelegate {
    func reloadCartView()
}

class CheckOutViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerPhoneNumberTextField: UITextField!
    @IBOutlet weak var paymentMethodSegmentControl: UISegmentedControl!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var expDateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    var customerLocation: GeoPoint!
    let firebaseHandler = FirebaseHandler()
    let coredataHandler = CoreDataHandler()
    var orderRestaurantList = [OrderRestaurant]()
    var delegate: CheckOutViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckOutViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        cardView.isHidden = true
        addressTextField.delegate = self
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func paymentMethodAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            cardView.isHidden = true
            break
        case 1:
            cardView.isHidden = false
            break
        default:
            cardView.isHidden = true
            break
        }
    }
    
    @IBAction func checkoutButtonAction(_ sender: UIButton) {
        self.checkOut { (orderRefString) in
            self.coredataHandler.deleteAllData(completionHandler: { (result) in
                self.showAlert(title: "Order Successfully", message: orderRefString)
            })
        }
        
    }
    
    func checkOut(completionHandler: @escaping(_ orderRefS: String) -> Void){
        var orderRefString: String = ""
        print("CHECK COUNT RESTAURANT")
        print(orderRestaurantList.count)
        for restaurant in 0 ..< orderRestaurantList.count {
            print(restaurant)
            let orderItems = orderRestaurantList[restaurant].orderFood?.allObjects as! [OrderFood]
            var totalPrice: Double = 0.0
            for item in orderItems {
                totalPrice = totalPrice + (Double(item.qty!)! * Double(item.price!)!)
            }
            
            firebaseHandler.getRestaurantLocationByID(restaurantID: orderRestaurantList[restaurant].restaurantID!) { (location) in
                self.firebaseHandler.setOrder(restaurantID: self.orderRestaurantList[restaurant].restaurantID!, custName: self.customerNameTextField.text!, custPhone: self.customerPhoneNumberTextField.text!, custAddress: self.addressTextField.text!, orderItem: orderItems, totalPrice: String(format: "%.2f", totalPrice), deliveryLocation: location, customerLocation: self.customerLocation) { (orderRef) in
                    orderRefString.append("\(self.orderRestaurantList[restaurant].restaurantName!) : \(orderRef) \n")
                    self.firebaseHandler.orderListener(restaurantID: self.orderRestaurantList[restaurant].restaurantID!, orderRef: orderRef)
                    self.firebaseHandler.setHistoryOrder(customerEmail: (Auth.auth().currentUser?.email)!, orderRef: orderRef, restaurantID: self.orderRestaurantList[restaurant].restaurantID!, restaurantName: self.orderRestaurantList[restaurant].restaurantName!)
                    if restaurant == self.orderRestaurantList.count - 1 {
                        completionHandler(orderRefString)
                    }
                }
            }
            
            
        }
    }

    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: {
                self.delegate?.reloadCartView()
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CheckOutViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressTextField {
            let autocompleteController = GMSAutocompleteViewController()
            let filter = GMSAutocompleteFilter()
            filter.country = "au"
            filter.type = .address
            autocompleteController.autocompleteFilter = filter
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
        
    }
}

extension CheckOutViewController : GMSAutocompleteViewControllerDelegate {
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
            addressTextField.text = street_number + " " + route + ", " + locality
        }
        customerLocation = GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
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
