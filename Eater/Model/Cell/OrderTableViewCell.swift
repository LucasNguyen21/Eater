//
//  OrderTableViewCell.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 18/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
