//
//  ViewController.swift
//  Festeller
//
//  Created by Igor Tro on 17/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    self.handeleFireAuthError(error: error)
                    debugPrint(error)
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            // We are logged in
       loginOutBtn.title = "Logout"
        } else {
            loginOutBtn.title = "Login"
        }
        
    }
    
    fileprivate func presentLoginVC() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC )
        present(controller, animated: true, completion: nil)
    }

    @IBAction func loginOutPressed(_ sender: Any) {
        
        // We are always logged in or either anonymously logged in
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            presentLoginVC()
        } else {
            do { try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        self.handeleFireAuthError(error: error)
                        debugPrint(error)
                    }
                self.presentLoginVC()
                }
            } catch {
                self.handeleFireAuthError(error: error)
                debugPrint(error)
            }
        }
    }
}

