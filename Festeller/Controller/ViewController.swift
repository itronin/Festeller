//
//  ViewController.swift
//  Festeller
//
//  Created by Igor Tro on 17/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC )
        present(controller, animated: true, completion: nil)
    }

}

