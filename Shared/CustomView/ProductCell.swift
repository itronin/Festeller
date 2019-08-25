//
//  ProductCell.swift
//  Festeller
//
//  Created by Igor Tro on 24/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    // Outlets
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell (product: Product) {
        
        productTitle.text = product.name
        
        if let url = URL (string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
    }
    
}
