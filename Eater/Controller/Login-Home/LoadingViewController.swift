//
//  LoadingViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 11/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var firebaseHandler: FirebaseHandler!
    var email: String?
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseHandler = FirebaseHandler()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingProcess { success in
            self.performSegue(withIdentifier: "loadingToMainSegue", sender: self)
            self.indicatorView.stopAnimating()
            
        }
        
    }
    
    func loadingProcess(completionHandler: @escaping (Bool) -> ()){
        if let email = email , let name = name {
            self.firebaseHandler.getCustomerInfo(customerEmail: email, completionHandler: { (customerInfo) in
                if customerInfo.name == "" {
                    self.firebaseHandler.setCustomerInfo(email: email, name: name, completionHandler: { (bool) in
                        completionHandler(true)
                    })
                } else {
                    print("2. \(customerInfo.name)")
                    completionHandler(true)
                }
            })
        } else {
            print("No email and name. Maybe second login")
            completionHandler(true)
        }
        
    }
}
