//
//  ForgotPasswordVC.swift
//  Festeller
//
//  Created by Igor Tro on 22/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPwdPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, email.isNotEmpty
            else {
            simpleAlert(title: "Error", msg: "Please input your email.")
            return}
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
//        let alert = UIAlertController(title: title, message: "email successfully sent", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
    }
}
