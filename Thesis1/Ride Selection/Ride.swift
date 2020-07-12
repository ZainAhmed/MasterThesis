//
//  Ride.swift
//  Thesis1
//
//  Created by Zain Sohail on 09.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

struct Ride{
    var image: UIImage
    var rideType: String
    var price: Double
    var eta: String
    var pickupTime: String
    
    init(image: UIImage, rideType: String, price: Double, eta: String, pickupTime: String) {
        self.image = image
        self.rideType = rideType
        self.price = price
        self.eta = eta
        self.pickupTime = pickupTime
    }
}
