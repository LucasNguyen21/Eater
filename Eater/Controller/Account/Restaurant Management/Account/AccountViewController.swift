//
//  AccountViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 27/4/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth

class AccountViewController: UIViewController {
    let firebaseHandler = FirebaseHandler()
    var restaurantID: String?
    @IBOutlet weak var restaurantManagerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = Auth.auth().currentUser?.email
        firebaseHandler.getCustomerInfo(customerEmail: email!) { (customerInfo) in
            if customerInfo.restaurantID == "" {
                self.restaurantManagerButton.setTitle("Create Restaurant", for: .normal)
            }
        }
    }
    @IBAction func restaurantManagerButtonAction(_ sender: UIButton) {
        if restaurantManagerButton.title(for: .normal) == "Create Restaurant" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let addToCartViewController =  storyBoard.instantiateViewController(withIdentifier: createRestaurantSID) as! CreateRestaurantViewController
            addToCartViewController.delegate = self
            //addToCartViewController.delegate = self
            self.present(addToCartViewController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: restaurantManagerSegue, sender: self)
        }
    }
    
    @IBAction func signOutButtonAction(_ sender: UIBarButtonItem) {
        facebookLogOut()
        googleLogOut()
        firebaseLogOut()
        appLogOut()
    }
    
    func facebookLogOut(){
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
    }
    
    func googleLogOut(){
        GIDSignIn.sharedInstance().signOut()
    }
    
    func firebaseLogOut(){
        try! Auth.auth().signOut()
    }
    
    func appLogOut(){
        clearUserDefault()
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyBoard.instantiateInitialViewController()!
        present(initialViewController, animated: true, completion: nil)
    }
    
    func clearUserDefault(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

extension AccountViewController : CreateRestaurantViewControllerDelegate {
    func reloadView() {
        let email = Auth.auth().currentUser?.email
        firebaseHandler.getCustomerInfo(customerEmail: email!) { (customerInfo) in
            if customerInfo.restaurantID == "" {
                self.restaurantManagerButton.setTitle("Create Restaurant", for: .normal)
            } else {
                self.restaurantManagerButton.setTitle("Restaurant Manager", for: .normal)
            }
        }
    }
    
    
}
