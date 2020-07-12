//
//  PastTripsTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 03.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class PastTripsTableViewCell: UITableViewCell {

    @IBOutlet weak var rideStatusLbl: UILabel!
    @IBOutlet weak var walkingDistanceLbl: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var passengerLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    //date
    //time
    func set(trips: PastTrips){
        rideStatusLbl.text = trips.rideStatus
        walkingDistanceLbl.text = trips.walkingDistanceTxt
        carType.text = trips.carType
        desLbl.text = trips.desTxt
        originLbl.text = trips.originTxt
        passengerLbl.text = trips.passengerCountTxt
        priceLbl.text = trips.costTxt
        setDateTime(date: trips.dateTxt)
    }
    
    func setDateTime(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let dateOfMonth = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        
        self.timeLbl.text = time
        self.dateLbl.text = dateOfMonth + " " + nameOfMonth
    }
}
