//
//  MakeRatingViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 9/6/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import STRatingControl

protocol MakeRatingViewControllerDelegate {
    func reloadData()
}

class MakeRatingViewController: UIViewController {

    @IBOutlet weak var ratingControl: STRatingControl!
    
    let firebaseHandler = FirebaseHandler()
    var restaurant: Restaurant!
    var delegate : MakeRatingViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        firebaseHandler.setReview(customerEmail: (Auth.auth().currentUser?.email)!, rating: String(ratingControl.rating), restaurantID: restaurant.id) { (bool) in
            self.dismiss(animated: true, completion: {
                self.delegate?.reloadData()
            })
        }
    }
    @IBAction func cancelActionButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
