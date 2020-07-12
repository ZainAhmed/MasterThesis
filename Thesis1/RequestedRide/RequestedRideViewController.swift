//
//  RequestedRideViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 18.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
class RequestedRideViewController: UIViewController {
    
    @IBOutlet weak var emergencyBtn: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    let graphHopperAPIKey = "Insert-Your-GraphHopperAPIKey"
    let collapsedTravelInfoHeight:CGFloat = 120
    let expandedTravelInfoHeight: CGFloat = 410
    let cornerRadius: CGFloat = 20.0
    let menuLauncher = MenuLauncher()
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    let dottedPolyline = GMSPolyline()
    
    var carCoordinates:[CLLocationCoordinate2D] = []
    var toPickupCoordinates: [CLLocationCoordinate2D] = []
    var toDesCoordinates: [CLLocationCoordinate2D] = []
    var originPos = CLLocationCoordinate2D()
    var desPos = CLLocationCoordinate2D()
    var dropOffLocation =  CLLocationCoordinate2D()
    var pickUpLocation = CLLocationCoordinate2D()
    var bounds = GMSCoordinateBounds()
    var pickUpLbl:String!
    var dropOffLbl:String!
    var pickUpLat: Double!
    var pickUpLong: Double!
    var dropOffLat: Double!
    var dropOffLong: Double!
    var rideType: RideTypeEnum!
    var curvePolylines: [GMSPolyline] = []
    var travelInfoViewController:TravelInfoViewController!
    var cardVisible = false
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    var iPosition:Int = 0;
    var pos:Int = 0
    var timer = Timer()
    var isLoaded:Bool = false
    var noPlate:String!
    var origin = ""
    var destination = destinationName.split(separator: ",")
    var timeToDes:String!
    var timeToPickup:String!
    var carModel:String!
    var carColor:String!
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.settings.rotateGestures = false;
        self.mapView.settings.tiltGestures = false;
        fetchData()
    }
    
    func fetchData(){
        let desLoc = Location(lat: destinationLat, lng: destinationLong, address: destinationName)
        let originLoc = Location(lat: originLat, lng: originLong, address: originName)
        let apiInput = RideInput(rideType: rideType, seats: String(passengerCount), walkingDistance: String(selectedDistance), userId: "123", originLocation: originLoc, destination: desLoc)
        UserAPI.requestRidePost(body: apiInput) { (RideRequest, Error) in
            self.dropOffLbl =  RideRequest!.dropOff?.address
            self.pickUpLbl = RideRequest?.pickUp?.address
            self.pickUpLat = (RideRequest?.pickUp?.lat)!
            self.pickUpLong = (RideRequest?.pickUp?.lng)!
            
            self.dropOffLat = (RideRequest?.dropOff?.lat)!
            self.dropOffLong = (RideRequest?.dropOff?.lng)!
            self.noPlate = (RideRequest?.numPlate)!
            self.timeToDes = RideRequest?.walkingTimeToDestination
            self.timeToPickup = RideRequest?.walkingTimeToPickup
            self.carModel = RideRequest?.model
            self.carColor = RideRequest?.color
            self.setupElements()
        }
    }
    
    func setupElements(){
        handleMap()
        setupCard()
        runAnimations()
    }
    
    func runAnimations(){
        let walkingMarker = setMarker(position: pickUpLocation, imageName: "nav")
            timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true, block: { (_) in
            do{
                self.playAnimation(stepsCoords: self.toPickupCoordinates, timer: self.timer, marker: walkingMarker!, zoom: 20)
                if(walkingMarker!.position.longitude == self.pickUpLocation.longitude && walkingMarker!.position.latitude == self.pickUpLocation.latitude){
                    
                    self.timer.invalidate()
                    self.runCarAnimation()
                    walkingMarker?.map = nil
                    
                }
            }
        })
    }
    
    func runCarAnimation(){
        let carMarker = setMarker(position: pickUpLocation, imageName: "icons8-car-top-view-50")
        timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true, block: { (_) in
            do{
                self.playAnimation(stepsCoords: self.carCoordinates, timer: self.timer, marker: carMarker!, zoom: 16)
                if(carMarker!.position.longitude == self.dropOffLocation.longitude && carMarker!.position.latitude == self.dropOffLocation.latitude){
                    self.timer.invalidate()
                    self.walkToDes()
                    carMarker?.map = nil
                }
            }
        })
        UIView.animate(withDuration: 0.5) {
            self.emergencyBtn.alpha = 1
            self.cancelButton.alpha = 0
        }
    }
    
    func walkToDes(){
        let walkingMarker = setMarker(position: pickUpLocation, imageName: "nav")
        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true, block: { (_) in
            do{
                self.playAnimation(stepsCoords: self.toDesCoordinates, timer: self.timer, marker: walkingMarker!, zoom: 18)
                if(walkingMarker!.position.longitude == self.desPos.longitude && walkingMarker!.position.latitude == self.desPos.latitude){
                    self.performSegue(withIdentifier: "toCompletionScreen", sender: self)
                    self.timer.invalidate()
                }
            }
        })
        UIView.animate(withDuration: 0.5) {
            self.emergencyBtn.alpha = 0
        }
    }
    
    func handleMap(){
        originPos = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        desPos = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        dropOffLocation =  CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: dropOffLat)!, longitude: CLLocationDegrees(exactly: dropOffLong)!)
        pickUpLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: pickUpLat)!, longitude: CLLocationDegrees(exactly: pickUpLong)!)
        
        mapView.delegate = self
        
        bounds = GMSCoordinateBounds(coordinate: pickUpLocation, coordinate: originPos)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 0)
        mapView.animate(with: update)
        
    }
    
    func drawCurvedLine(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        getPolyline(startLocation: endLocation, endLocation: startLocation, pointsPerDistance:20.0)
    }
    

    func getPolyline(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, pointsPerDistance: Double) {
        let linePath = GMSMutablePath()
        let url = "https://graphhopper.com/api/1/route?point="+String(startLocation.latitude)+","+String(startLocation.longitude) + "&point=" + String(endLocation.latitude) + "," + String(endLocation.longitude) + "&vehicle=car&debug=true&key=" + graphHopperAPIKey + "&type=json&points_encoded=false"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let coordinates = json["paths"][0]["points"]["coordinates"]

                    linePath.add(startLocation)
                    let initialCoord = coordinates[0].arrayObject
                    let initialLat = (initialCoord![1] as! NSNumber).doubleValue
                    let initialLong = (initialCoord![0] as! NSNumber).doubleValue
                    self.addPointsforCarAnimation(startPt: CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: initialLat)!, longitude: CLLocationDegrees(exactly: initialLong)!), endPt: startLocation, pointsPerDistance: pointsPerDistance)
                    for i in 1...coordinates.count-1 {
                        
                        let curCoord = coordinates[i].arrayObject
                        let curLat = (curCoord![1] as! NSNumber).doubleValue
                        let curLong = (curCoord![0] as! NSNumber).doubleValue
                        let prevCoord = coordinates[i-1].arrayObject
                        let prevLat = (prevCoord![1] as! NSNumber).doubleValue
                        let prevLong = (prevCoord![0] as! NSNumber).doubleValue
                        let startPt = (CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: prevLat)!, longitude: CLLocationDegrees(exactly: prevLong)!))
                        let endPt = (CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: curLat)!, longitude: CLLocationDegrees(exactly: curLong)!))
                        linePath.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: curLat)!, longitude: CLLocationDegrees(exactly: curLong)!))
                        self.addPointsforCarAnimation(startPt: startPt, endPt: endPt, pointsPerDistance: pointsPerDistance)

                        if(i == coordinates.count-1){
                            linePath.add(endLocation)
                        }
                    }
                    
                    self.carCoordinates.append(endLocation)
                    let polyline = GMSPolyline(path: linePath)
                    polyline.map = self.mapView
                    polyline.strokeWidth = 5.0
                    polyline.strokeColor = self.blue

                case .failure(let error):
                    print("Request failed with error: \(error)")
            }
        }
    }
    
    func addPointsforCarAnimation(startPt: CLLocationCoordinate2D, endPt: CLLocationCoordinate2D, pointsPerDistance: Double){
        let latDiff = (endPt.latitude - startPt.latitude) / pointsPerDistance
        let longDiff = (endPt.longitude - startPt.longitude) / pointsPerDistance
        var tempPt = startPt
         self.carCoordinates.append(startPt)
        for _ in 0...Int(pointsPerDistance)-2 {
            tempPt.latitude = tempPt.latitude + latDiff
            tempPt.longitude = tempPt.longitude + longDiff
            self.carCoordinates.append(tempPt)
        }
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
    
    func drawDottedLine(polyline: GMSPolyline, on map: GMSMapView, startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, toPickUp:Bool) {
        let path = GMSMutablePath()
        path.add(startLocation)
        toPickUp ? toPickupCoordinates.append(startLocation): toDesCoordinates.append(startLocation)
        path.add(endLocation)
        
        
        let intervalDistanceIncrement: CGFloat = 10
        let circleRadiusScale = 1 / map.projection.points(forMeters: 1, at: map.camera.target)
        var previousCircle: GMSCircle?
        for coordinateIndex in 0 ..< path.count() - 1 {
            let startCoordinate = path.coordinate(at: coordinateIndex)
            let endCoordinate = path.coordinate(at: coordinateIndex + 1)
            let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
            let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
            let pathDistance = endLocation.distance(from: startLocation)
            let intervalLatIncrement = (endLocation.coordinate.latitude - startLocation.coordinate.latitude) / pathDistance
            let intervalLngIncrement = (endLocation.coordinate.longitude - startLocation.coordinate.longitude) / pathDistance
            for intervalDistance in 0 ..< Int(pathDistance) {
                let intervalLat = startLocation.coordinate.latitude + (intervalLatIncrement * Double(intervalDistance) )
                let intervalLng = startLocation.coordinate.longitude + (intervalLngIncrement * Double(intervalDistance))
                let circleCoordinate = CLLocationCoordinate2D(latitude: intervalLat, longitude: intervalLng)
                if let previousCircle = previousCircle {
                    let circleLocation = CLLocation(latitude: circleCoordinate.latitude,
                                                    longitude: circleCoordinate.longitude)
                    let previousCircleLocation = CLLocation(latitude: previousCircle.position.latitude,
                                                            longitude: previousCircle.position.longitude)
                    if map.projection.points(forMeters: circleLocation.distance(from: previousCircleLocation),
                                             at: map.camera.target) < intervalDistanceIncrement {
                        continue
                    }
                }
                
                let circleRadius = 3 * CLLocationDistance(circleRadiusScale)
                let circle = GMSCircle(position: circleCoordinate, radius: circleRadius)
                toPickUp ? toPickupCoordinates.append(circleCoordinate): toDesCoordinates.append(circleCoordinate)
                circle.strokeColor = blue
                circle.fillColor = blue
                circle.map = map
                previousCircle = circle
            }
        }
        toPickUp ? toPickupCoordinates.append(endLocation): toDesCoordinates.append(endLocation)
    }
    

    
    func playAnimation(stepsCoords: [CLLocationCoordinate2D],timer: Timer, marker:GMSMarker, zoom:Float){
        if(iPosition <= stepsCoords.count - 1){
            let position = stepsCoords[iPosition]
            marker.position = position
            mapView.camera = GMSCameraPosition(target: position, zoom: zoom, bearing: 0, viewingAngle: 0)
            marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            marker.map = self.mapView
            if iPosition != stepsCoords.count - 1 {
                marker.rotation = CLLocationDegrees(exactly: self.getHeadingForDirection(fromCoordinate: stepsCoords[iPosition], toCoordinate: stepsCoords[iPosition+1]))!
            }
            if iPosition == stepsCoords.count - 1 {
                iPosition = 0;
                timer.invalidate()
            }
            iPosition += 1
        }
    }
    
    func setMarker(position: CLLocationCoordinate2D, imageName: String) -> GMSMarker?{
        let marker = GMSMarker(position: position)
        marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        marker.icon =  UIImage(named: imageName)!
        marker.map = self.mapView
        return marker
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree - 180.0
        }
        else {
            return (360 + degree) - 180
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let rideCancellationInput = RideCancellationInput(vehicleId: "123", userId: "123")
        UserAPI.cancelRidePost(body: rideCancellationInput) { (RideCancellationResponse, Error) in
            let status = RideCancellationResponse!.status!
            switch(status){
            case RideStatusEnum.canceled:
                var origin = ""
                print(destinationName)
                var destination = destinationName.split(separator: ",")
                if(originName == "Current Location"){
                    origin = "Ponttor"
                } else {
                    origin = originName
                }
                let trip = PastTrips(carType: "Express", walkingDistanceTxt: String(selectedDistance), passengerCountTxt: String(passengerCount), rideStatus: "Cancelled", dateTxt: Date(), costTxt: String(3.08), originTxt: origin, desTxt: String(destination[0]))
                pastTrips.append(trip)
                self.timer.invalidate()
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
                self.performSegue(withIdentifier: "backToHome", sender: self)
            default:
                print("default")
            }
        }
        
    }
    @IBAction func menuTapped(_ sender: Any) {
        menuLauncher.showMenu()
        menuLauncher.menuDelegate = self
        menuLauncher.profileDelegate = self
    }
  
    
    func setupCard() {
        emergencyBtn.alpha = 0
        buttonView.layer.cornerRadius = 30
        buttonView.clipsToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        travelInfoViewController = TravelInfoViewController(nibName:"TravelInfoViewController", bundle:nil)
        self.addChild(travelInfoViewController)
        self.view.addSubview(travelInfoViewController.view)
        self.travelInfoViewController.view.frame = CGRect(x: 25, y: self.view.frame.height - self.collapsedTravelInfoHeight, width: self.view.bounds.width-50, height: self.collapsedTravelInfoHeight)
        travelInfoViewController.view.clipsToBounds = true
        self.travelInfoViewController.view.layer.cornerRadius = cornerRadius
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        travelInfoViewController.dropOffLbl.text = dropOffLbl
        travelInfoViewController.pickupLbl.text = pickUpLbl
        travelInfoViewController.walkingtoPickupLbl.text = self.timeToPickup + " Minutes walk to Pickup Point"
        travelInfoViewController.walkingToDestinationLbl.text = self.timeToDes + " Minutes walk to Destination"
        travelInfoViewController.carColor.text = self.carColor
        travelInfoViewController.carModel.text = self.carModel
        if(originName == "Current Location"){
            origin = "Ponttor"
        } else {
            origin = originName
        }
        
        travelInfoViewController.destinationLbl.text = destinationName
        travelInfoViewController.currentLocationLbl.text = origin
        travelInfoViewController.noPlate.text = self.noPlate
        travelInfoViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.4)
        case .changed:
            let translation = recognizer.translation(in: self.travelInfoViewController.handleArea)
            var fractionComplete = translation.y / expandedTravelInfoHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.travelInfoViewController.view.frame = CGRect(x: 25, y: self.view.frame.height - self.expandedTravelInfoHeight, width: self.view.bounds.width-50, height: self.expandedTravelInfoHeight )
                case .collapsed:
                    self.travelInfoViewController.view.frame = CGRect(x: 25, y: self.view.frame.height - self.collapsedTravelInfoHeight, width: self.view.bounds.width-50, height: self.collapsedTravelInfoHeight)
                }
            }

            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }

            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)

            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.travelInfoViewController.view.layer.cornerRadius = self.cornerRadius
                case .collapsed:
                    self.travelInfoViewController.view.layer.cornerRadius = self.cornerRadius
                }
            }

            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
extension RequestedRideViewController: MenuToggleProtocol{
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

extension RequestedRideViewController:ProfileToggleProtocol{
    func toggleProfile() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.profileViewController) as? ProfileViewController{
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension RequestedRideViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        drawDottedLine(polyline: dottedPolyline, on: mapView, startLocation: originPos, endLocation: pickUpLocation, toPickUp: true)
        drawDottedLine(polyline: dottedPolyline, on: mapView, startLocation: dropOffLocation, endLocation: desPos, toPickUp: false)
        drawCurvedLine(startLocation: dropOffLocation, endLocation: pickUpLocation)
        addOriginMarkerOnMap(location: originPos)
        addDestinationMarkerOnMap(location: desPos)
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

