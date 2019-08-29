//
//  Firebase_Utils.swift
//  Festeller
//
//  Created by Igor Tro on 23/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import Firebase

extension Firestore {
    
    var categories: Query {
        return collection("categories").order(by: "timeStamp", descending: true)
    }
    
}

extension Auth {
    
    func handleFireAuthError (error: Error, vc: UIViewController) {
        
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
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
