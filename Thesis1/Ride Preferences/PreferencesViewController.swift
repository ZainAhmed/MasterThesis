//
//  PreferencesViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 13.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import WWCalendarTimeSelector

class PreferencesViewController: UIViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var laterBtn: UIButton!
    @IBOutlet weak var nowBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var passengerCountLbl: UILabel!
    @IBOutlet weak var zeroM: UIButton!
    @IBOutlet weak var tFiftyM: UIButton!
    @IBOutlet weak var fiveHundredM: UIButton!
    @IBOutlet weak var selectedDistanceLbl: UILabel!
    
    var scheduleDate:Date!
    var polylines: [GMSPolyline] = []
    var selectedDate:Date = Date()
    let menuLauncher = MenuLauncher()
    let selector = WWCalendarTimeSelector.instantiate()
    let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selector.delegate = self
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpElements(){
        laterBtn.layer.borderWidth = 1
        nowBtn.layer.borderWidth = 1
        plusBtn.layer.borderWidth = 2
        minusBtn.layer.borderWidth = 2
        zeroM.layer.borderWidth = 1
        tFiftyM.layer.borderWidth = 1
        fiveHundredM.layer.borderWidth = 1
        laterBtn.layer.borderColor = blue.cgColor
        nowBtn.layer.borderColor = blue.cgColor
        plusBtn.layer.borderColor = blue.cgColor
        minusBtn.layer.borderColor = blue.cgColor
        zeroM.layer.borderColor = blue.cgColor
        tFiftyM.layer.borderColor = blue.cgColor
        fiveHundredM.layer.borderColor = blue.cgColor
        buttonView.layer.cornerRadius = 30
        buttonView.clipsToBounds = true
        passengerCountLbl.text = String(passengerCount)
        distanceSelected(distance: selectedDistance)
        nowLaterBtnSelected()
        setupDatePicker()
        setupMap()
    }
    
    func setupMap(){
        mapView.clear()
        let originPos = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        let desPos = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        drawCurve(startLocation: originPos, endLocation: desPos)
    }
    
    
    func drawCurve(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        let path = GMSMutablePath()
        let SE = GMSGeometryDistance(startLocation, endLocation)
        let angle = Double.pi / 4
        let ME = SE / 2.0
        let R = ME / sin(angle / 2)
        let MO = R * cos(angle / 2)
        let heading = GMSGeometryHeading(startLocation, endLocation)
        let mCoordinate = GMSGeometryOffset(startLocation, ME, heading)
        let direction = (startLocation.longitude - endLocation.longitude > 0) ? -1.0 : 1.0
        let angleFromCenter = 90.0 * direction
        let oCoordinate = GMSGeometryOffset(mCoordinate, MO, heading + angleFromCenter)
        addOriginMarkerOnMap(location: startLocation)
        path.add(endLocation)
        addDestinationMarkerOnMap(location: endLocation)
        
        let num = 100
        let initialHeading = GMSGeometryHeading(oCoordinate, endLocation)
        let degree = (180.0 * angle) / Double.pi
        for i in 1...num {
            let step = Double(i) * (degree / Double(num))
            let heading : Double = (-1.0) * direction
            let pointOnCurvedLine = GMSGeometryOffset(oCoordinate, R, initialHeading + heading * step)
            path.add(pointOnCurvedLine)
        }
        path.add(startLocation)
        addOriginMarkerOnMap(location: startLocation)
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        polyline.strokeWidth = 2.0
        polyline.strokeColor = blue
    }
    
    func addOriginMarkerOnMap(location: CLLocationCoordinate2D){
        let marker = GMSMarker(position: location)
        marker.icon = UIImage(named: "origin")
        marker.title = "Origin"
        marker.map = mapView
    }
    
    func addDestinationMarkerOnMap(location: CLLocationCoordinate2D){
        let marker = GMSMarker(position: location)
        marker.icon = UIImage(named: "destination")
        marker.title = "Destination"
        marker.map = mapView
    }
    
    func setupDatePicker(){
        selector.optionSelectorPanelFontColorTimeHighlight = yellow
        selector.optionButtonShowCancel = true
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
        
        if(scheduledTime != nil){
            dateBtn.setTitle(scheduledTime, for: UIControl.State.normal)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        menuLauncher.showMenu()
        menuLauncher.menuDelegate = self
        menuLauncher.profileDelegate = self
    }
    
    @IBAction func fiveHundredSelected(_ sender: Any) {
        distanceSelected(distance: 500)
    }
    
    @IBAction func twoFiftySelected(_ sender: Any) {
        distanceSelected(distance: 250)
    }
    
    @IBAction func zeroSelected(_ sender: Any) {
        distanceSelected(distance: 0)
    }
    
    @IBAction func nowTapped(_ sender: Any) {
        nowSelected = true
        nowLaterBtnSelected()
    }
    
    @IBAction func laterTapped(_ sender: Any) {
        nowSelected = false
        nowLaterBtnSelected()
        if(scheduledTime == nil){
            present(selector, animated: true, completion: nil)
        }
    }
    
    @IBAction func insertDateTapped(_ sender: Any) {
        present(selector, animated: true, completion: nil)
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        if(passengerCount > 1){
            passengerCount = passengerCount - 1
            passengerCountLbl.text = String(passengerCount)
        }
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        if(passengerCount < 6){
            passengerCount = passengerCount + 1
            passengerCountLbl.text = String(passengerCount)
        }
    }
    
    @IBAction func getOfferTapped(_ sender: Any) {
        performSegue(withIdentifier: "toRideSelection", sender: self)
        //        if(nowSelected == true){
        //            performSegue(withIdentifier: "toRideSelection", sender: self)
        //        } else {
        //            var origin = ""
        //            var destination = destinationName.split(separator: ",")
        //            if(originName == "Current Location"){
        //                origin = "Ponttor"
        //            } else {
        //                origin = originName
        //            }
        //            let trip = Trips(passengers: passengerCountLbl.text!, origin: origin, destination: String(destination[0]), date: selectedDate, walkingDistance: String(selectedDistance), daysStack: [], latOrigin: originLat, longOrigin: originLong, latDestination: destinationLat, longDestination: originLong)
        //            scheduledTrips.append(trip)
        //            performSegue(withIdentifier: "toSuccessfullSchedule", sender: self)
        //        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(nowSelected == false){
            if(segue.identifier == "toRideSelection"){
                if let vc = segue.destination as? RideSelectionViewController {
                    vc.scheduleDate = scheduleDate
                }
            }
        }
    }
    func distanceSelected(distance: Double){
        selectedDistance  = distance
        switch distance{
            
        case 0:
            selectedDistanceLbl.text = "Get picked and dropped at exact location:"
            zeroM.layer.backgroundColor = blue.cgColor
            zeroM.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            tFiftyM.layer.backgroundColor = UIColor.white.cgColor
            tFiftyM.setTitleColor(blue, for: UIControl.State.normal)
            
            fiveHundredM.layer.backgroundColor = UIColor.white.cgColor
            fiveHundredM.setTitleColor(blue, for: UIControl.State.normal)
        case 250:
            selectedDistanceLbl.text = "Walk upto 250 m to and from the ride:"
            
            tFiftyM.layer.backgroundColor = blue.cgColor
            tFiftyM.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            zeroM.layer.backgroundColor = UIColor.white.cgColor
            zeroM.setTitleColor(blue, for: UIControl.State.normal)
            
            fiveHundredM.layer.backgroundColor = UIColor.white.cgColor
            fiveHundredM.setTitleColor(blue, for: UIControl.State.normal)
        case 500:
            selectedDistanceLbl.text = "Walk upto 500 m to and from the ride:"
            
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
    
    func nowLaterBtnSelected(){
        if(nowSelected == true){
            nowBtn.layer.backgroundColor = blue.cgColor
            nowBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            laterBtn.layer.backgroundColor = UIColor.white.cgColor
            laterBtn.setTitleColor(blue, for: UIControl.State.normal)
            //            continueBtn.setTitle("Get Offer", for: .normal)
            dateBtn.isHidden = true
        } else {
            laterBtn.layer.backgroundColor = blue.cgColor
            laterBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            nowBtn.layer.backgroundColor = UIColor.white.cgColor
            nowBtn.setTitleColor(blue, for: UIControl.State.normal)
            //            continueBtn.setTitle("Schedule Ride", for: .normal)
            dateBtn.isHidden = false
        }
        continueBtn.setTitle("Get Offer", for: .normal)
    }
}

extension PreferencesViewController: WWCalendarTimeSelectorProtocol{
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        let dateFormatter = DateFormatter()
        selectedDate = date
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let dateOfMonth = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        scheduleDate = date
        scheduledTime = String(dateOfMonth) + " " + String(nameOfMonth) + " " + String(year) + " at " + String(time)
        dateBtn.setTitle(scheduledTime, for: UIControl.State.normal)
    }
}

extension PreferencesViewController: MenuToggleProtocol{
    func toggleMenu(menuName: String) {
        let menu = menuName
        switch menu{
        case "Payments":
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.paymentsViewController) as? AddPaymentsViewController{
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        case "Trips":
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.tripsViewController) as? TripsViewController{
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        case "Help":
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.helpViewController) as? HelpViewController{
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        default:
            print("default")
        }
    }
}

extension PreferencesViewController:ProfileToggleProtocol{
    func toggleProfile() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.profileViewController) as? ProfileViewController{
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
