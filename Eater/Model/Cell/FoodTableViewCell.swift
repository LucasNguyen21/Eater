//
//  FoodTableViewCell.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 17/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseStorage
import Alamofire
import AlamofireImage

protocol FoodTableViewCellDelegate {
    func displayAddFood(food: Food)
}

class FoodTableViewCell: UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var delegate: FoodTableViewCellDelegate?
    var food: Food?
    let firebaseHandler = FirebaseHandler()
    override func awakeFromNib() {
        super.awakeFromNib()
        indicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFood(food: Food){
        indicator.startAnimating()
        self.food = food
        foodNameLabel.text = food.name
        downloadImage(urlString: food.imagePath) { (image) in
            self.foodImageView.image = image
            self.indicator.stopAnimating()
        }
        priceLabel.text = "$ " + food.price
        descriptionLabel.text = food.description
    }
    
    func downloadImage(urlString: String, completionHandler: @escaping (_ image: UIImage) -> Void ){
        firebaseHandler.downloadImage(urlString: urlString, imageView: foodImageView) { (image) in
            completionHandler(image)
        }
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        delegate?.displayAddFood(food: food!)
    }
    
}
