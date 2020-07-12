//
//  TripsViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 14.02.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {

    @IBOutlet weak var pastTripsTableView: UITableView!
    @IBOutlet weak var tripsTableview: UITableView!
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var pastBtn: UIButton!
    
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    var editIndex: Int!
    var upcomingSelected:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setupElements()
    }
    
    func setupElements(){
        roundTopCorners(btn: upcomingBtn)
        roundTopCorners(btn: pastBtn)
        selectPastUpcomingBtnSelected(isUpcomingSelected: true)
        tripsTableview.delegate = self
        tripsTableview.dataSource = self
        pastTripsTableView.delegate = self
        pastTripsTableView.dataSource = self
        tripsTableview.reloadData()
        tripsTableview.tableFooterView = UIView(frame: CGRect.zero)
        pastTripsTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func roundTopCorners(btn: UIButton){
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 6
        btn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func selectPastUpcomingBtnSelected(isUpcomingSelected: Bool){
        if(isUpcomingSelected == true){
            upcomingBtn.setTitleColor(blue, for: .normal)
            upcomingBtn.backgroundColor = UIColor.white
            pastBtn.setTitleColor(UIColor.white, for: .normal)
            pastBtn.backgroundColor = blue
            tripsTableview.isHidden = false
            pastTripsTableView.isHidden = true
        } else {
            pastBtn.setTitleColor(blue, for: .normal)
            pastBtn.backgroundColor = UIColor.white
            upcomingBtn.setTitleColor(UIColor.white, for: .normal)
            upcomingBtn.backgroundColor = blue
            tripsTableview.isHidden = true
            pastTripsTableView.isHidden = false
        }
    }
    
    func createAlert(title: String, message:String, indexPath:IndexPath){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {(action) in
            scheduledTrips.remove(at: indexPath.row)
            self.tripsTableview.beginUpdates()
            self.tripsTableview.deleteRows(at: [indexPath], with: .automatic)
            self.tripsTableview.endUpdates()
            self.tripsTableview.reloadData()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func upcomingTapped(_ sender: Any) {
        
        upcomingSelected = true
        selectPastUpcomingBtnSelected(isUpcomingSelected: upcomingSelected)
    }
    
    @IBAction func pastTapped(_ sender: Any) {
        upcomingSelected = false
        selectPastUpcomingBtnSelected(isUpcomingSelected: upcomingSelected)
    }
    
}

extension TripsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tripsTableview){
            return  scheduledTrips.count
        } else if(tableView == pastTripsTableView){
            return  pastTrips.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tripsTableview){
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! TripsTableViewCell
            cell.indexPath = indexPath
            let trips = scheduledTrips[indexPath.row]
            cell.set(trips: trips)
            cell.cellDelegate = self
            return cell
        }else if(tableView == pastTripsTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "pastCell", for: indexPath) as! PastTripsTableViewCell
            let trips = pastTrips[indexPath.row]
            cell.set(trips: trips)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == pastTripsTableView){
        return 132
        } else if(tableView == tripsTableview){
           return 163
        }
        return 132
    }
    
}

extension TripsViewController: ScheduleTripProtocol{
    func deleteCell(indexPath: IndexPath) {
        createAlert(title: "Delete", message: "Are you sure you want to delete the scheduled ride?", indexPath: indexPath)
    }
    
    func editCell(index: Int) {
        editIndex = index
        performSegue(withIdentifier: "toEditScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toEditScreen"){
            let vc = segue.destination as! TripsTimeViewController
            vc.des = scheduledTrips[editIndex].destination
            vc.origin = scheduledTrips[editIndex].origin
            vc.passenger = Int(scheduledTrips[editIndex].passengers)
            vc.walkingDistance = Double(scheduledTrips[editIndex].walkingDistance)
            vc.oldDate = scheduledTrips[editIndex].date
            vc.cameFrom = "SavedTrips"
            vc.scheduledTripIndex = editIndex
            vc.desLat = scheduledTrips[editIndex].latDestination
            vc.desLong = scheduledTrips[editIndex].longDestination
            vc.orgLat = scheduledTrips[editIndex].latOrigin
            vc.orgLong = scheduledTrips[editIndex].longOrigin
            vc.rideType = scheduledTrips[editIndex].rideType
            if(scheduledTrips[editIndex].daysStack.count == 0){
                vc.onceSelected = true
            } else {
                vc.onceSelected = false
                for day in scheduledTrips[editIndex].daysStack{
                    
                    switch(day){
                        case "Sun":
                            vc.isSunSelected = true
                        case "Mon":
                            vc.isMonSelected = true
                        case "Tues":
                            vc.isTuesSelected = true
                        case "Wed":
                            vc.isWedSelected = true
                        case "Thu":
                            vc.isThursSelected = true
                        case "Fri":
                            vc.isFriSelected = true
                        case "Sat":
                            vc.isSatSelected = true
                        default:
                            print("default")
                    }
                }
            }
        }
    } 
}
