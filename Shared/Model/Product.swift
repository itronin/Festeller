//
//  Product.swift
//  Festeller
//
//  Created by Igor Tro on 24/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imgURL: String
    var timeStamp: Timestamp
    var stock: Int
    
    init (data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imgURL = data["imgURL"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
}
