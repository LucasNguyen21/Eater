//
//  Menu.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation

class Menu {
    var suicine: String!
    var food: [Food]!
    
    init(suicine: String, food: [Food]) {
        self.suicine = suicine
        self.food = food
    }
}
