//
//  ReviewTableViewCell.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import STRatingControl

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var ratingControl: STRatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
