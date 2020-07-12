//
//  ScheduledRideTypeViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 08.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
protocol setRideTypeProtocol{
    func setRideType(newRrideType:String)
}
class ScheduledRideTypeViewController: UIViewController {

    @IBOutlet weak var scheduledRideTypeTableView: UITableView!
    
    let rideTypes = ["Express","Comfort","Luxury","Electric", "SUV Express","SUV Comfort","SUV Luxury","SUV Electric","Wheelchair Accessible Vehicle"]
    var selectedRideTypeIndex: Int!
    var scheduledRideIndex: Int!
    var selectedRideType: String!
    var rideTypeDelegate: setRideTypeProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledRideTypeTableView.delegate = self
        scheduledRideTypeTableView.dataSource = self
        
        scheduledRideTypeTableView.selectRow(at: IndexPath(row: selectedRideTypeIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
        scheduledRideTypeTableView.delegate?.tableView?(scheduledRideTypeTableView, didSelectRowAt: IndexPath(row: selectedRideTypeIndex, section: 0))
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        rideTypeDelegate.setRideType(newRrideType: selectedRideType)
//            viewParentController.rideType = selectedRideType
        navigationController?.popViewController(animated: true)
        
    }
}


extension ScheduledRideTypeViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "schduledRideTypeCell", for: indexPath) as! ScheduledRideTypeTableViewCell
        let ride = rideTypes[indexPath.row]
        switch(ride){
            case "Express":
                cell.setRideType(rideIcon: "Express", rideLbl: ride)
            case "Comfort":
                cell.setRideType(rideIcon: "Comfort", rideLbl: ride)
            case "Luxury":
                cell.setRideType(rideIcon: "Luxury", rideLbl: ride)
            case "Electric":
                cell.setRideType(rideIcon: "Electric", rideLbl: ride)
            case "SUV Express":
                cell.setRideType(rideIcon: "suvExpress", rideLbl: ride)
            case "SUV Comfort":
                cell.setRideType(rideIcon: "suvComfort", rideLbl: ride)
            case "SUV Luxury":
                cell.setRideType(rideIcon: "suvLuxury", rideLbl: ride)
            case "SUV Electric":
                cell.setRideType(rideIcon: "suvElectric", rideLbl: ride)
            case "Wheelchair Accessible Vehicle":
                cell.setRideType(rideIcon: "WAV", rideLbl: ride)
            default:
                print("default")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRideType = rideTypes[indexPath.row]
    }
}
