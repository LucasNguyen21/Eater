//
//  Food.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation
import UIKit

class Food {
    var name: String!
    var imagePath: String!
    var price: String!
    var description: String!
    var cuisine: String!
    var imageName: String!
    
    init(name: String, imagePath: String, price: String, description: String, cuisine: String, imageName: String) {
        self.name = name
        self.imagePath = imagePath
        self.price = price
        self.description = description
        self.cuisine = cuisine
        self.imageName = imageName
    }
}
