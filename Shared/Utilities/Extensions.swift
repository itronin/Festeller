//
//  File.swift
//  Festeller
//
//  Created by Igor Tro on 18/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    func handleFireAuthError (error: Error) {
        
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showForgotPWDVC() {
        let forgotPasswordVC = ForgotPasswordVC()
        forgotPasswordVC.modalTransitionStyle = .crossDissolve
        forgotPasswordVC.modalPresentationStyle = .overCurrentContext
        present(forgotPasswordVC, animated: true, completion: nil)
    }
    
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Prease contact suppor."
        case .invalidEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please check your connection"
        case .weakPassword:
            return "The password must be 6 characters or more."
        case .wrongPassword:
            return "Your password or email is incorrect"
        
        default:
            return "Sorry, something went wrong."
        }
    }
}
