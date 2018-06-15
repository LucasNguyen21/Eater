//
//  LoginHandler.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 27/4/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginHandler{
    func checkLogin(window: UIWindow){
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()!
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()!
        }
    }
}
