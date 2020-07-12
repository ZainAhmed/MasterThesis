//
//  ScheduledTripsTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 01.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
protocol ScheduleTripProtocol{
    func deleteCell(indexPath: IndexPath)
    func editCell(index: Int)
}
class TripsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var rideTypeLbl: UILabel!
    @IBOutlet weak var daysStack: UIStackView!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var walkingDistance: UILabel!
    @IBOutlet weak var passengers: UILabel!
    @IBOutlet weak var desName: UILabel!
    @IBOutlet weak var originName: UILabel!
    
    var indexPath:IndexPath!
    var cellDelegate: ScheduleTripProtocol!
    
    let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    
    @IBAction func editTapped(_ sender: Any) {
        cellDelegate?.editCell(index: indexPath!.row)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        cellDelegate?.deleteCell(indexPath: indexPath!)
    }
    
    func set(trips: Trips){
        originName.text = trips.origin
        desName.text = trips.destination
        passengers.text = trips.passengers
        walkingDistance.text = trips.walkingDistance
        rideTypeLbl.text = trips.rideType
        initaliseDays(days: trips.daysStack)
        setTime(tripsDate: trips.date)
    }
    
    func setTime(tripsDate: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: tripsDate)
        
        dateFormatter.dateFormat = "dd"
        let dateOfMonth = dateFormatter.string(from: tripsDate)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: tripsDate)
        
        self.time.text = time
        self.date.text = dateOfMonth + " " + nameOfMonth
    }
    
    func initaliseDays(days: [String]){
        if(days.count == 0){
            daysStack.isHidden = true
        } else {
            date.isHidden = true
            for day in days{
                switch(day){
                    case "Sun":
                        sunday.setTitleColor(yellow, for: .normal)
                    case "Mon":
                        monday.setTitleColor(yellow, for: .normal)
                    case "Tues":
                        tuesday.setTitleColor(yellow, for: .normal)
                    case "Wed":
                        wednesday.setTitleColor(yellow, for: .normal)
                    case "Thu":
                        thursday.setTitleColor(yellow, for: .normal)
                    case "Fri":
                        friday.setTitleColor(yellow, for: .normal)
                    case "Sat":
                        saturday.setTitleColor(yellow, for: .normal)
                    default:
                        print("default")
                }
            }
        }
    }
}
