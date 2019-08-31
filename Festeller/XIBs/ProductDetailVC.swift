//
//  ProductDetailVC.swift
//  Festeller
//
//  Created by Igor Tro on 31/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    // Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = product.name
        productDescription.text = product.productDescription
        
        if let url = URL(string: product.imgURL) {
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCartPressed(_ sender: Any) {
        // Add product to cart
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
