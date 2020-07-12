//
//  ScheduledRideTypeTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 08.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class ScheduledRideTypeTableViewCell: UITableViewCell {

   
    @IBOutlet weak var scheduledRideTypeLbl: UILabel!
    @IBOutlet weak var scheduledRideTypeImage: UIImageView!
    
    let selectionView = UIView()
    let selectionBlue = UIColor(red: 0/255.0, green: 115/255.0, blue: 156.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.layer.masksToBounds = true
        selectionView.layer.cornerRadius = 6
        selectionView.layer.borderWidth = 3
        selectionView.layer.borderColor = selectionBlue.cgColor
        
        self.selectedBackgroundView = selectionView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRideType(rideIcon:String,rideLbl:String){
        scheduledRideTypeLbl.text = rideLbl
        scheduledRideTypeImage.image = UIImage(named: rideIcon)
    }
}
