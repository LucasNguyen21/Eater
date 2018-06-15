//
//  AddFoodViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
protocol AddFoodViewControllerDelegate {
    func reloadData()
}

class AddFoodViewController: UIViewController {
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageIndicatorView: UIView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var deleteButton: UIButton!
    var firebaseHandler: FirebaseHandler!
    var delegate: AddFoodViewControllerDelegate?
    var food: Food?
    var status: String = "Add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseHandler = FirebaseHandler()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFoodViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        indicatorView.isHidden = true
        imageIndicatorView.isHidden = true
        indicator.hidesWhenStopped = true
        imageIndicator.hidesWhenStopped = true
        setUpView()
    }
    
    func setUpView(){
        if let food = food {
            foodNameTextField.text = food.name
            priceTextField.text = food.price
            descTextField.text = food.description
            startImageIndicator()
            firebaseHandler.downloadImage(urlString: food.imagePath, imageView: foodImageView) { (image) in
                self.foodImageView.image = image
                self.stopImageIndicator()
            }
            categoryTextField.text = food.cuisine
            navigationItem.title = "Update"
        } else {
            deleteButton.isHidden = true
            foodNameTextField.isEnabled = true
            categoryTextField.isEnabled = true
        }
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        alertDeleteMessage(title: "Caution!!!", message: "Do you want to delete this food?")
    }
    @IBAction func pickImageButtonAction(_ sender: UIButton) {
        pickImage()
        
    }
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        startIndicator()
        if status == "Add" {
            firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
                self.firebaseHandler.setFood(restaurantID: restaurantID, foodName: self.foodNameTextField.text!, image: self.foodImageView.image!, price: self.priceTextField.text!, suicine: self.categoryTextField.text!, description: self.descTextField.text!) { (success) in
                    self.stopIndicator()
                    self.alertMessage(title: "Upload Item", message: "Successfully")
                }
            }
            
        } else {
            firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!) { (restaurantID) in
                self.firebaseHandler.deleteFood(restaurantID: restaurantID, foodName: (self.food?.name)!, imageName: (self.food?.imageName)!, completionHandler: { (bool) in
                    self.firebaseHandler.setFood(restaurantID: restaurantID, foodName: self.foodNameTextField.text!, image: self.foodImageView.image!, price: self.priceTextField.text!, suicine: self.categoryTextField.text!, description: self.descTextField.text!) { (success) in
                        self.stopIndicator()
                        self.alertMessage(title: "Update Item", message: "Successfully")
                    }
                })
            }
            
        }
        
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func startImageIndicator(){
        imageIndicatorView.isHidden = false
        imageIndicator.startAnimating()
    }
    
    func stopImageIndicator(){
        imageIndicatorView.isHidden = true
        imageIndicator.stopAnimating()
    }
    
    func startIndicator(){
        indicatorView.isHidden = false
        indicator.startAnimating()
    }
    
    func stopIndicator(){
        indicatorView.isHidden = true
        indicator.stopAnimating()
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
    
    func alertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            self.delegate?.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertDeleteMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.startIndicator()
            self.firebaseHandler.getRestaurantId(customerEmail: (Auth.auth().currentUser?.email)!, completionHandler: { (restaurantID) in
                self.firebaseHandler.deleteFood(restaurantID: restaurantID, foodName: (self.food?.name)!, imageName: (self.food?.imageName)!, completionHandler: { (result) in
                    self.stopIndicator()
                    self.alertMessage(title: "Delete", message: "Successfully")
                })
            })
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddFoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            foodImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

