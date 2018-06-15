//
//  CreateRestaurantViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 7/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import GooglePlaces
import FirebaseFirestore

protocol CreateRestaurantViewControllerDelegate {
    func reloadView()
}

class CreateRestaurantViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cuisineTextField: UITextField!
    
    @IBOutlet weak var logoImageView: UIImageView!
    var delegate: CreateRestaurantViewControllerDelegate?
    let firebaseHandler = FirebaseHandler()
    var location: GeoPoint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateRestaurantViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        addressTextField.delegate = self
    }
    @IBAction func pickImageButtonAction(_ sender: UIButton) {
        pickImage()
    }
    @IBAction func createRestaurantButtonAction(_ sender: UIButton) {
        firebaseHandler.countNumberOfRestaurants { (numberString) in
            self.firebaseHandler.setRestaurant(id: numberString, logo: self.logoImageView.image!, cuisine: self.cuisineTextField.text!, name: self.nameTextField.text!, ownerEmail: (Auth.auth().currentUser?.email)!, address: self.addressTextField.text!, location: self.location, completionHandler: { (bool) in
                self.dismiss(animated: true, completion: {
                    self.delegate?.reloadView()
                })
            })
        }
        
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func pickImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

}

extension CreateRestaurantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            logoImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateRestaurantViewController: UITextFieldDelegate {
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

extension CreateRestaurantViewController : GMSAutocompleteViewControllerDelegate {
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
        location = GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
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
