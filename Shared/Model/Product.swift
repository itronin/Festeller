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
    
    init(
            name: String,
            id: String,
            category: String,
            price: Double,
            productDescription: String,
            imgURL: String,
            timeStamp: Timestamp = Timestamp(),
            stock: Int = 0
        ) {
            self.name = name
            self.id = id
            self.category = category
            self.price = price
            self.productDescription = productDescription
            self.imgURL = imgURL
            self.timeStamp = timeStamp
            self.stock = stock
        }
    
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
    
    static func modelToData(product: Product) -> [String: Any] {
                let data : [String : Any] = [
                    "name" : product.name,
                    "id" : product.id,
                    "category" : product.category,
                    "price" : product.price,
                    "productDescription" : product.productDescription,
                    "imgURL" : product.imgURL,
                    "timeStamp" : product.timeStamp,
                    "stock" : product.stock
                ]
                return data
            }
}

extension Product : Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
