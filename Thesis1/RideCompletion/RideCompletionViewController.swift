//
//  RideCompletionViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 29.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class RideCompletionViewController: UIViewController {

    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    func setupElements(){
        yesBtn.layer.borderWidth = 2
        yesBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        noBtn.layer.borderWidth = 2
        noBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        var origin = ""
        var destination = destinationName.split(separator: ",")
        if(originName == "Current Location"){
            origin = "Ponttor"
        } else {
            origin = originName
        }
        let trip = PastTrips(carType: "Express", walkingDistanceTxt: String(selectedDistance), passengerCountTxt: String(passengerCount), rideStatus: "Completed", dateTxt: Date(), costTxt: String(3.08), originTxt: origin, desTxt: String(destination[0]))
        pastTrips.append(trip)
        
    }
    
    @IBAction func yesTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSavePreferences", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSavePreferences"){
            let vc = segue.destination as! TripsTimeViewController
            vc.des = String(destinationName.split(separator: ",")[0])
            if(originName == "Current Location"){
                vc.origin = "Ponttor"
            } else {
                vc.origin = String(originName.split(separator: ",")[0])
            }
            
            
            vc.walkingDistance = selectedDistance
            vc.passenger = passengerCount
            vc.cameFrom = "rideCompletion"
            vc.onceSelected = false
            vc.desLat = destinationLat
            vc.desLong = destinationLong
            vc.orgLat = originLat
            vc.orgLong = originLong
            vc.rideType = selectedRideType
            
        }
    }
    
    @IBAction func noTapped(_ sender: Any) {
        originLat = nil
        originLong = nil
        originName = nil
        destinationLat = nil
        destinationLong = nil
        destinationName = nil
        findCurrentLocation = true
        nowSelected = true
        scheduledTime = nil
        dismissNot = false
        selectedDistance = 250;
        passengerCount = 1
        selectedRideType = "Express"
        performSegue(withIdentifier: "completionToHome", sender: self)
    }
    
    @IBAction func crossTapped(_ sender: Any) {
        originLat = nil
        originLong = nil
        originName = nil
        destinationLat = nil
        destinationLong = nil
        destinationName = nil
        findCurrentLocation = true
        nowSelected = true
        scheduledTime = nil
        dismissNot = false
        selectedDistance = 250;
        passengerCount = 1
        performSegue(withIdentifier: "completionToHome", sender: self)
    }
}
