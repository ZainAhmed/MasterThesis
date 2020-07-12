//
//  SavedPaymentsTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 21.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

protocol SavedPaymentProtocol{
    func setAsDefault(index: Int)
}

class SavedPaymentsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var savePaymentBtn: UIButton!
    @IBOutlet weak var defaultPaymentImg: UIImageView!
    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    
    var cellDelegate: SavedPaymentProtocol?
    var indexPath: IndexPath?
    
    func setPaymentMethod(savedCards: SavedCards){
        paymentIcon.image = savedCards.image
        cardNumber.text = savedCards.cardNumber
        defaultPaymentImg.image = savedCards.defaultImage
    }
    
    @IBAction func setAsDefaultTapped(_ sender: Any) {
        print("Index row in saved Payments Cell \(String(describing: indexPath))")
        cellDelegate?.setAsDefault(index: (indexPath?.row)!)
    }
}
