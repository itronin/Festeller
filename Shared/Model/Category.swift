//
//  Category.swift
//  Festeller
//
//  Created by Igor Tro on 23/08/2019.
//  Copyright © 2019 Igor Tro. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgURL: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
