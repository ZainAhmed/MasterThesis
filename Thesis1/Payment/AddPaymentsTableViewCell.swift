//
//  AddPaymentsTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 18.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class AddPaymentsTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    func setPaymentOptions(paymentOption: PaymentOptions){
        img.image = paymentOption.image
        label.text = paymentOption.title
    }
}
