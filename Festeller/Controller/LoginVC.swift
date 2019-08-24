//
//  LoginVC.swift
//  Festeller
//
//  Created by Igor Tro on 18/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        showForgotPWDVC()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields")
                return
                
        }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error  {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestPressed(_ sender: Any) {
    }
    
}
