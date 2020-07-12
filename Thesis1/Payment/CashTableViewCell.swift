//
//  CashTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 09.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

protocol CashCellProtocol{
    func  setAsDefault()
}

class CashTableViewCell: UITableViewCell {

    @IBOutlet weak var setDefaultBtn: UIButton!
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var Lbl: UILabel!
    
    var delegate: CashCellProtocol!
    
    func setPaymentMethod(savedCards: SavedCards){
        paymentIcon.image = savedCards.image
        Lbl.text = savedCards.cardNumber
        defaultImg.image = savedCards.defaultImage
    }
    @IBAction func setAsDefaultTapped(_ sender: Any) {
        delegate!.setAsDefault()
    }
}
