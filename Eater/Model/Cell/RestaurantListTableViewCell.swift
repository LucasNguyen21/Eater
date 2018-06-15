//
//  RestaurantListTableViewCell.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 13/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseStorage
import AlamofireImage
import Alamofire
import STRatingControl

class RestaurantListTableViewCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAreaLabel: UILabel!
    @IBOutlet weak var restaurantCuisineLabel: UILabel!
    @IBOutlet weak var ratingControl: STRatingControl!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var restaurant: Restaurant!
    let firebaseHandler = FirebaseHandler()
    override func awakeFromNib() {
        super.awakeFromNib()
        indicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRestaurant(restaurant: Restaurant){
        self.restaurant = restaurant
        indicator.startAnimating()
        downloadImage(urlString: restaurant.logo) { (image) in
            self.restaurantImage.image = image
            self.indicator.stopAnimating()
        }
        restaurantNameLabel.text = restaurant.name
        restaurantAreaLabel.text = restaurant.surburb
        ratingControl.rating = Int(restaurant.rating)!
        restaurantCuisineLabel.text = restaurant.cuisine
    }
    
    func downloadImage(urlString: String, completionHandler: @escaping (_ image: UIImage) -> Void ){
        firebaseHandler.downloadImage(urlString: urlString, imageView: restaurantImage) { (image) in
            completionHandler(image)
        }
    }
}
