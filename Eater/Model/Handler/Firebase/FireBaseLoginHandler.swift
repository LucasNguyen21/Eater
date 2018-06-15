//
//  FireBaseLogginHandler.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 27/4/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class FireBaseLoginHandler {
    func loginToFireBase(credential: AuthCredential, completionHandler: @escaping (_ bool: Bool)-> Void){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error == nil {
                
                print("Facebook to Firebase success")
                completionHandler(true)
            } else {
                print("Facebook to Firebase error")
                print(error!)
                let errorCode = error! as NSError
                if errorCode.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    print("Email Already In Use")
                }
                if errorCode.code == AuthErrorCode.invalidCredential.rawValue {
                    print("invalid cre")
                }
                if errorCode.code == AuthErrorCode.customTokenMismatch.rawValue {
                    print("not match token")
                }
                if errorCode.code == AuthErrorCode.accountExistsWithDifferentCredential.rawValue {
                    print("Account different")
                }
                completionHandler(false)
            }
        }
    }
    
}
