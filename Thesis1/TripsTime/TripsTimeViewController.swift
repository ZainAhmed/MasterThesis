//
//  TripsTimeViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 30.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import CoreLocation
import WWCalendarTimeSelector

class TripsTimeViewController: UIViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var daysStack: UIStackView!
    @IBOutlet weak var wedBtn: UIButton!
    @IBOutlet weak var monBtn: UIButton!
    @IBOutlet weak var thursBtn: UIButton!
    @IBOutlet weak var satBtn: UIButton!
    @IBOutlet weak var friBtn: UIButton!
    @IBOutlet weak var tuesBtn: UIButton!
    @IBOutlet weak var sunBtn: UIButton!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var passengerLbl: UILabel!
    @IBOutlet weak var zeroM: UIButton!
    @IBOutlet weak var tFiftyM: UIButton!
    @IBOutlet weak var fiveHundredM: UIButton!
    @IBOutlet weak var rideTypeBtn: UIButton!
    @IBOutlet weak var paymentTypeBtn: UIButton!
    @IBOutlet weak var desLbl: UIButton!
    @IBOutlet weak var originLbl: UIButton!
    
    
    var rideType:String!
    var oldDate: Date!
    var onceSelected:Bool!
    var isDateSelected:Bool!
    var isTimeSelected:Bool!
    var isMonSelected:Bool!
    var isTuesSelected:Bool!
    var isWedSelected:Bool!
    var isThursSelected:Bool!
    var isFriSelected:Bool!
    var isSatSelected:Bool!
    var isSunSelected:Bool!
    var selectedDays:[String] = []
    
    var isOriginTapped: Bool!
    var des:String!
    var origin:String!
    var passenger: Int!
    var walkingDistance: Double!
    var desLat: CLLocationDegrees!
    var desLong: CLLocationDegrees!
    var orgLat: CLLocationDegrees!
    var orgLong: CLLocationDegrees!
    var cameFrom:String!
    var scheduledTripIndex: Int!
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupElements()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func selectOnceRegularBtnSelected(isOnceSelected: Bool){
        if(isOnceSelected == true){
            dateBtn.isHidden = false
            daysStack.isHidden = true
            
          
            
            dateImage.image = UIImage(named: "icons8-pay-date-48")
            dateLbl.text = "Date:"
        } else {
            dateBtn.isHidden = true
            daysStack.isHidden = false
            
            
            dateImage.image = UIImage(named: "icons8-planner-48")
            dateLbl.text = "Days:"
        }
    }
    func setupElements(){
        selectOnceRegularBtnSelected(isOnceSelected: onceSelected)
        if(oldDate == nil){
          oldDate = Date()
        } else {
            dateformater(date: oldDate)
        }
        setupDays()
        rideTypeBtn.setTitle(rideType, for: .normal)
        originLbl.setTitle(origin, for: .normal)
        desLbl.setTitle(des, for: .normal)
        passengerLbl.text = String(passenger)
//        cancelBtn.layer.borderColor = yellow.cgColor
//        cancelBtn.layer.borderWidth = 1
        plusBtn.layer.borderWidth = 2
        minusBtn.layer.borderWidth = 2
        zeroM.layer.borderWidth = 1
        tFiftyM.layer.borderWidth = 1
        fiveHundredM.layer.borderWidth = 1
        plusBtn.layer.borderColor = blue.cgColor
        minusBtn.layer.borderColor = blue.cgColor
        zeroM.layer.borderColor = blue.cgColor
        tFiftyM.layer.borderColor = blue.cgColor
        fiveHundredM.layer.borderColor = blue.cgColor
        distanceSelected(distance: walkingDistance)
       
    }
    func setupDays(){
        if(isSatSelected == true){
            satBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Sat")
        }
        
        if(isSunSelected == true){
            sunBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Sun")
        }
        
        if(isMonSelected == true){
            monBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Mon")
        }
        
        if(isTuesSelected == true){
            tuesBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Tues")
        }
        
        if(isWedSelected == true){
            wedBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Wed")
        }
        
        if(isThursSelected == true){
            thursBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Thu")
        }
        
        if(isFriSelected == true){
            friBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Fri")
        }
    }
    func setupSelector(selector: WWCalendarTimeSelector){
        selector.optionButtonShowCancel = true
        selector.optionSelectorPanelFontColorTimeHighlight = yellow
        selector.optionBottomPanelBackgroundColor = blue
        selector.optionCalendarFontColorMonth = blue
        selector.optionButtonBackgroundColorCancel = blue
        selector.optionButtonBackgroundColorDone = blue
        selector.optionButtonFontColorDone = .white
        selector.optionButtonFontColorCancel = .white
        selector.optionClockFontColorHour = blue
        selector.optionTopPanelFontColor = .white
        selector.optionTopPanelBackgroundColor = blue
        selector.optionSelectorPanelFontColorTime = .white
        selector.optionCalendarBackgroundColorFutureDatesHighlight = blue
        selector.optionCalendarFontColorMonth = .white
        selector.optionSelectorPanelFontColorMonth = .white
        selector.optionSelectorPanelFontColorYear = .white
        selector.optionClockBackgroundColorMinuteHighlightNeedle = blue
        selector.optionClockBackgroundColorHourHighlightNeedle = blue
        selector.optionClockBackgroundColorAMPMHighlight = blue
        selector.optionCalendarBackgroundColorPastDatesFlash = blue
        selector.optionClockFontColorHourHighlight = .white
        selector.optionClockFontColorAMPM = blue
        selector.optionSelectorPanelFontColorDate = .white
        selector.optionCalendarUnderlinedBackgroundColor = blue
        selector.optionSelectorPanelBackgroundColor = blue
        selector.optionCalendarFontColorDays = blue
        selector.optionCalendarBackgroundColorPastDatesHighlight = blue
        selector.optionCalendarBackgroundColorTodayHighlight = blue
        selector.optionCalendarFontColorCurrentYearHighlight = yellow
        selector.optionCalendarFontColorPastYearsHighlight = yellow
        selector.optionCalendarFontColorFutureYearsHighlight = yellow
        selector.optionCalendarFontColorCurrentYear = blue
        selector.optionCalendarFontColorPastYears = blue
        selector.optionCalendarFontColorFutureYears = blue
        selector.optionClockBackgroundColorHourHighlight = blue
        selector.optionClockBackgroundColorMinuteHighlight = blue
    }
    
    func distanceSelected(distance: Double){
        selectedDistance = distance
        switch distance{
            
            case 0:
                zeroM.layer.backgroundColor = blue.cgColor
                zeroM.setTitleColor(UIColor.white, for: UIControl.State.normal)
                tFiftyM.layer.backgroundColor = UIColor.white.cgColor
                tFiftyM.setTitleColor(blue, for: UIControl.State.normal)
                fiveHundredM.layer.backgroundColor = UIColor.white.cgColor
                fiveHundredM.setTitleColor(blue, for: UIControl.State.normal)
            
            case 250:
                tFiftyM.layer.backgroundColor = blue.cgColor
                tFiftyM.setTitleColor(UIColor.white, for: UIControl.State.normal)
                zeroM.layer.backgroundColor = UIColor.white.cgColor
                zeroM.setTitleColor(blue, for: UIControl.State.normal)
                fiveHundredM.layer.backgroundColor = UIColor.white.cgColor
                fiveHundredM.setTitleColor(blue, for: UIControl.State.normal)
            
            case 500:
                fiveHundredM.layer.backgroundColor = blue.cgColor
                fiveHundredM.setTitleColor(UIColor.white, for: UIControl.State.normal)
                zeroM.layer.backgroundColor = UIColor.white.cgColor
                zeroM.setTitleColor(blue, for: UIControl.State.normal)
                tFiftyM.layer.backgroundColor = UIColor.white.cgColor
                tFiftyM.setTitleColor(blue, for: UIControl.State.normal)
            
            default:
                print("default")
        }
    }
    
  
    
    func dateformater(date: Date){
        let dateFormatter = DateFormatter()
        
        if(onceSelected == true){
            dateFormatter.dateFormat = "LLLL"
            let nameOfMonth = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "dd"
            let dateOfMonth = dateFormatter.string(from: date)
            let dateText = String(dateOfMonth) + " " + String(nameOfMonth)
            dateBtn.setTitle(dateText, for: .normal)
        }
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        timeBtn.setTitle(time, for: .normal)
    }
    

    
    
    @IBAction func sunTapped(_ sender: Any) {
        
        if(isSunSelected == false || isSunSelected == nil){
            sunBtn.setTitleColor(yellow, for: .normal)
            selectedDays.append("Sun")
            isSunSelected = true
        } else {
            sunBtn.setTitleColor(blue, for: .normal)
            isSunSelected = false
            selectedDays = selectedDays.filter { $0 != "Sun" }
        }
    }
    
    @IBAction func monTapped(_ sender: Any) {
        if(isMonSelected == false || isMonSelected == nil){
            monBtn.setTitleColor(yellow, for: .normal)
            isMonSelected = true
            selectedDays.append("Mon")
        } else {
            monBtn.setTitleColor(blue, for: .normal)
            isMonSelected = false
            selectedDays = selectedDays.filter { $0 != "Mon" }
        }
    }
    
    @IBAction func tuesTapped(_ sender: Any) {
        if(isTuesSelected == false || isTuesSelected == nil){
            tuesBtn.setTitleColor(yellow, for: .normal)
            isTuesSelected = true
            selectedDays.append("Tues")
        } else {
            tuesBtn.setTitleColor(blue, for: .normal)
            isTuesSelected = false
            selectedDays = selectedDays.filter { $0 != "Tues" }
        }
    }
    
    @IBAction func wedTapped(_ sender: Any) {
        if(isWedSelected == false || isWedSelected == nil){
            wedBtn.setTitleColor(yellow, for: .normal)
            isWedSelected = true
            selectedDays.append("Wed")
        } else {
            wedBtn.setTitleColor(blue, for: .normal)
            isWedSelected = false
            selectedDays = selectedDays.filter { $0 != "Wed" }
        }
    }
    
    @IBAction func thursTapped(_ sender: Any) {
        if(isThursSelected == false || isThursSelected == nil){
            thursBtn.setTitleColor(yellow, for: .normal)
            isThursSelected = true
            selectedDays.append("Thu")
        } else {
            thursBtn.setTitleColor(blue, for: .normal)
            isThursSelected = false
            selectedDays = selectedDays.filter { $0 != "Thu" }
        }
    }
    
    @IBAction func friTapped(_ sender: Any) {
        if(isFriSelected == false || isFriSelected == nil){
            friBtn.setTitleColor(yellow, for: .normal)
            isFriSelected = true
            selectedDays.append("Fri")
        } else {
            friBtn.setTitleColor(blue, for: .normal)
            isFriSelected = false
            selectedDays = selectedDays.filter { $0 != "Fri" }
        }
    }
    
    @IBAction func satTapped(_ sender: Any) {
        if(isSatSelected == false || isSatSelected ==  nil){
            satBtn.setTitleColor(yellow, for: .normal)
            isSatSelected = true
            selectedDays.append("Sat")
        } else {
            satBtn.setTitleColor(blue, for: .normal)
            isSatSelected = false
            selectedDays = selectedDays.filter { $0 != "Sat" }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        if(cameFrom == "rideCompletion"){
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
            performSegue(withIdentifier: "preferencesToHome", sender: self)
        } else if(cameFrom == "SavedTrips"){
             navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func zeroTapped(_ sender: Any) {
        distanceSelected(distance: 0)
    }
    
    @IBAction func tFiftyTapped(_ sender: Any) {
        distanceSelected(distance: 250)
    }
    
    @IBAction func fiveHundredTapped(_ sender: Any) {
        distanceSelected(distance: 500)
    }
    @IBAction func plusTapped(_ sender: Any) {
        if(passengerCount < 6){
            passengerCount = passengerCount + 1
            passengerLbl.text = String(passengerCount)
        }
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        if(passengerCount > 1){
            passengerCount = passengerCount - 1
            passengerLbl.text = String(passengerCount)
        }
    }
    
    @IBAction func rideTypeTapped(_ sender: Any) {
        performSegue(withIdentifier: "toScheduledRideType", sender: self)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
         if(cameFrom == "rideCompletion"){
            if((isTimeSelected == nil) || ((isMonSelected == false || isMonSelected == nil) && (isTuesSelected == false || isTuesSelected == nil) && (isWedSelected == false || isWedSelected == nil) && (isThursSelected == false || isThursSelected == nil) && (isFriSelected == false || isFriSelected == nil) && (isSatSelected == false || isSatSelected == nil) && (isSunSelected == false || isSunSelected == nil))){
                createAlert(title: "Error", message: "Please insert Date and Days" )
            } else {
                if(onceSelected == true){
                    let trip = Trips(passengers: passengerLbl.text!, origin: (originLbl.titleLabel?.text!)!, destination: (desLbl.titleLabel?.text!)!, date: oldDate, walkingDistance: String(selectedDistance), daysStack: [], latOrigin: orgLat, longOrigin: orgLong, latDestination: desLat, longDestination: desLong, rideType: rideType)
                    scheduledTrips.append(trip)
                } else{
                    let trip = Trips(passengers: passengerLbl.text!, origin: (originLbl.titleLabel?.text!)!, destination: (desLbl.titleLabel?.text!)!, date: oldDate, walkingDistance: String(selectedDistance), daysStack:selectedDays, latOrigin: orgLat, longOrigin: orgLong, latDestination: desLat, longDestination: desLong, rideType: rideType)
                    scheduledTrips.append(trip)
                }
                selectedRideType = "Express"
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
                performSegue(withIdentifier: "preferencesToHome", sender: self)
            }
         } else if(cameFrom == "SavedTrips"){
            if(onceSelected == true){
                let trip = Trips(passengers: passengerLbl.text!, origin: (originLbl.titleLabel?.text!)!, destination: (desLbl.titleLabel?.text!)!, date: oldDate, walkingDistance: String(selectedDistance), daysStack: [], latOrigin: orgLat, longOrigin: orgLong, latDestination: desLat, longDestination: desLong, rideType: rideType)
                scheduledTrips[scheduledTripIndex] = trip
            } else{
                let trip = Trips(passengers: passengerLbl.text!, origin: (originLbl.titleLabel?.text!)!, destination: (desLbl.titleLabel?.text!)!, date: oldDate, walkingDistance: String(selectedDistance), daysStack:selectedDays, latOrigin: orgLat, longOrigin: orgLong, latDestination: desLat, longDestination: desLong, rideType: rideType)
                scheduledTrips[scheduledTripIndex] = trip
            }
            navigationController?.popViewController(animated: true)        }
    }
    
    func createAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func dateBtnTapped(_ sender: Any) {
        isDateSelected = true
        let selector = WWCalendarTimeSelector.instantiate()
        setupSelector(selector: selector)
        selector.delegate = self
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(false)
        selector.optionCurrentDate = oldDate
        
        present(selector, animated: true, completion: nil)
    }
    
    @IBAction func timeBtnTapped(_ sender: Any) {
        isTimeSelected = true
        let selector = WWCalendarTimeSelector.instantiate()
        setupSelector(selector: selector)
        selector.delegate = self
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        selector.optionCurrentDate = oldDate
        present(selector, animated: true, completion: nil)
    }
    
    @IBAction func originTapped(_ sender: Any) {
        
        isOriginTapped = true
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    
    @IBAction func destinationTapped(_ sender: Any) {
        isOriginTapped = false
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "addLocation"){
            if let vc = segue.destination as? MapLocationViewController {
                vc.prevController = "TripsTime"
                // checking if button was tapped by Origin textfield
                if(isOriginTapped == true){
                    vc.cameFrom = "origin"
                    vc.serachBarText = self.origin
                    vc.latitude = orgLat
                    vc.longitude = orgLong
                } else if(isOriginTapped == false){
                    vc.cameFrom = "destination"
                    vc.serachBarText = self.des
                    vc.latitude = desLat
                    vc.longitude = desLong
                    vc.orgLong = self.orgLong
                    vc.orgLat = self.orgLat
                }
                vc.delegate = self
            }
        } else if(segue.identifier == "toScheduledRideType"){
            if let vc = segue.destination as? ScheduledRideTypeViewController {
                vc.rideTypeDelegate = self
                switch(rideType){
                    case "Express":
                        vc.selectedRideTypeIndex = 0
                    case "Comfort":
                        vc.selectedRideTypeIndex = 1
                    case "Luxury":
                        vc.selectedRideTypeIndex = 2
                    case "Electric":
                        vc.selectedRideTypeIndex = 3
                    case "SUV Express":
                        vc.selectedRideTypeIndex = 4
                    case "SUV Comfort":
                        vc.selectedRideTypeIndex = 5
                    case "SUV Luxury":
                        vc.selectedRideTypeIndex = 6
                    case "SUV Electric":
                        vc.selectedRideTypeIndex = 7
                    case "Wheelchair Accessible Vehicle":
                        vc.selectedRideTypeIndex = 8
                    default:
                        print("default")
                }
                vc.scheduledRideIndex = scheduledTripIndex
            }
        }
    }
}

extension TripsTimeViewController:MapLocationProtocol{
    func setLocation(lat: CLLocationDegrees, long: CLLocationDegrees, locationName: String, cameFrom: String) {
        if(cameFrom == "origin"){
            orgLat = lat
            orgLong = long
            originLbl.setTitle(locationName, for: .normal)
        } else if(cameFrom == "destination"){
            desLong = long
            desLat = lat
            desLbl.setTitle(locationName, for: .normal)
        }
    }
}
extension TripsTimeViewController: WWCalendarTimeSelectorProtocol{
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        let dateFormatter = DateFormatter()
        
        if(isDateSelected == true){
            dateFormatter.dateFormat = "LLLL"
            let nameOfMonth = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "dd"
            let dateOfMonth = dateFormatter.string(from: date)
            let dateText = String(dateOfMonth) + " " + String(nameOfMonth)
            dateBtn.setTitle(dateText, for: .normal)
            oldDate = date
            isDateSelected = false
        }
        
        if(isTimeSelected == true){
            dateFormatter.dateFormat = "HH:mm"
            let time = dateFormatter.string(from: date)
            timeBtn.setTitle(time, for: .normal)
            oldDate = date
            isTimeSelected = false
        }
    }
}

extension TripsTimeViewController: setRideTypeProtocol{
    func setRideType(newRrideType: String) {
        self.rideType = newRrideType
        self.viewWillAppear(true)
    }
}
