//
//  CategoryCell.swift
//  Festeller
//
//  Created by Igor Tro on 23/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImg.layer.cornerRadius = 5
    }

    func  configureCell (category: Category ) {
        categoryLbl.text = category.name
        if let url = URL (string: category.imgURL) {
            categoryImg.kf.setImage(with: url)
        }
    }
}