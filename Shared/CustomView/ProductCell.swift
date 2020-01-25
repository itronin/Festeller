//
//  ProductCell.swift
//  Festeller
//
//  Created by Igor Tro on 24/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate : class {
    func productFavorited(product : Product)
}

class ProductCell: UITableViewCell {

    // Outlets
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate : ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell (product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate 
        productTitle.text = product.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if let url = URL (string: product.imgURL) {
            let placeholder = UIImage(named: AppImages.Placeholder)
            productImg.kf.indicatorType = .activity
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        if UserService.favorites.contains(product) {
            favoriteButton.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
        
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
    
}
