//
//  LoginViewController.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 27/4/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var gmailView: UIView!

    var firebaseHandler = FireBaseLoginHandler()
    var firebase = FirebaseHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        createLoginButton(facebookView: facebookView)
        createGmailLoginButton()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func createGmailLoginButton(){
        let gmailLoginButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        gmailLoginButton.translatesAutoresizingMaskIntoConstraints = false
        gmailView.addSubview(gmailLoginButton)
        gmailLoginButton.topAnchor.constraint(equalTo: gmailView.topAnchor, constant: -5).isActive = true
        gmailLoginButton.leftAnchor.constraint(equalTo: gmailView.leftAnchor, constant: -5).isActive = true
        gmailLoginButton.rightAnchor.constraint(equalTo: gmailView.rightAnchor, constant: 5).isActive = true
        gmailLoginButton.bottomAnchor.constraint(equalTo: gmailView.bottomAnchor, constant: 5).isActive = true
        
    }
    
    func createLoginButton(facebookView: UIView){
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookView.addSubview(loginButton)
        let centerX = NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: facebookView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: loginButton, attribute: .centerY, relatedBy: .equal, toItem: facebookView, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: facebookView, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: facebookView, attribute: .width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([centerX, centerY, height, width])
        loginButton.delegate = self
    }
}

extension LoginViewController : GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        } else {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            firebaseHandler.loginToFireBase(credential: credential) { (bool) in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyBoard.instantiateInitialViewController()!
                self.present(initialViewController, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print("Login Fail \(error)")
        case .cancelled:
            print("User cancelled login")
            
        case .success(grantedPermissions: _, declinedPermissions: _, token: let accessToken):
            print("Login Success")
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            let firebaseHandler = FireBaseLoginHandler()
            firebaseHandler.loginToFireBase(credential: credential) { (bool) in
                self.getGraphRequestConnection(accessToken: accessToken)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func getGraphRequestConnection(accessToken: AccessToken){
        let graphRequestConnection = GraphRequestConnection()
        graphRequestConnection.add(GraphRequest(graphPath: "/me", parameters: ["fields" : "id, email, name, picture.type(large)"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)) {
            httpResponse, result in
            switch result {
            case .success(response: let response):
                print("Get Graph Request Success")
                if response.dictionaryValue != nil {
                    let json: JSON?
                    var name = ""
                    var email = ""
                    
                    json =  JSON(response.dictionaryValue!)

                    if let _name = json?["name"].stringValue {
                        name = _name
                    }
                    if let _email = json?["email"].stringValue {
                        email = _email
                    }
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loadingViewController =  storyBoard.instantiateViewController(withIdentifier: loadingViewSID) as! LoadingViewController
                    loadingViewController.email = email
                    loadingViewController.name = name
                    self.present(loadingViewController, animated: true, completion: nil)
                }
                break
            case .failed(let error):
                print(error)
                break
            }
        }
        graphRequestConnection.start()
    }
}
