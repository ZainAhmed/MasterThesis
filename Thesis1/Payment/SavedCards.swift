//
//  SavedCards.swift
//  Thesis1
//
//  Created by Zain Sohail on 21.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import Foundation
import UIKit

class SavedCards{
    var cardNumber: String
    var image: UIImage
    var defaultImage: UIImage
    var isDefault:Bool
    
    init(cardNumber: String, image: UIImage, defaultImage: UIImage, isDefault: Bool) {
        self.cardNumber = cardNumber
        self.image = image
        self.defaultImage = defaultImage
        self.isDefault = isDefault
    }
    
}
