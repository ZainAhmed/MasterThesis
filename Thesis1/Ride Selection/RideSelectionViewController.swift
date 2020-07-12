//
//  RideSelectionViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 31.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class RideSelectionViewController: UIViewController {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var sortPicker: UIPickerView!
    @IBOutlet weak var requestRideBtn: UIButton!
    
    enum RideListState{
        case expanded
        case collapsed
    }
    
    let blackView = UIView()
    
    let collapsedShowableRegion:CGFloat = 410
    let collapsedRideListHeight:CGFloat = 300
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    
    var sortOptions = ["Price: Low-High","Pickup Time: Earliest-Latest","Pickup Time: Latest-Earliest","ETA: Earliest-Latest","ETA: Latest-Earliest"]
    var selectedSortOption: String!
    var rideListCardViewController: RideListCardViewController!
    var expandedRideListHeight: CGFloat!
    var visualEffectView: UIVisualEffectView!
    var runningAnimations = [UIViewPropertyAnimator]()
    var scheduleDate: Date!
    var animationProgressWhenInterrupted: CGFloat = 0
    var isListExpanded = false
    var polylines: [GMSPolyline] = []
    var nextState: RideListState {
        return isListExpanded ? .collapsed : .expanded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expandedRideListHeight = self.view.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupMap()
        setupRequestBtn()
        setSelectedRideType()
    }
    
    func setSelectedRideType(){
        if(selectedRideType == nil){
            selectedRideType = "Express"
        }
    }
    func setupRequestBtn(){
        if(nowSelected == true){
            requestRideBtn.setTitle("Request Ride", for: .normal)
        } else {
            requestRideBtn.setTitle("Schedule Ride", for: .normal)
            paymentIcon.isHidden = true
            paymentLabel.isHidden = true
        }
    }
    func setupMap(){
        MapView.clear()
        let originPos = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        let desPos = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        draw(startLocation: originPos, endLocation: desPos)
        setupRideList()
        setPaymentMethod()
    }
    
    func draw(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        let polyline = getPolyline(startLocation: startLocation, endLocation: endLocation)!
        polylines.append(polyline)
    }
    
    func getPolyline(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) -> GMSPolyline? {
        
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
        MapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
        let polyline = GMSPolyline(path: path)
        polyline.map = MapView
        polyline.strokeWidth = 2.0
        polyline.strokeColor = blue
        
        return polyline
    }
    
    func addOriginMarkerOnMap(location: CLLocationCoordinate2D){
        let marker = GMSMarker(position: location)
        marker.icon = UIImage(named: "origin")
        marker.title = "Origin"
        marker.map = MapView
    }
    
    func addDestinationMarkerOnMap(location: CLLocationCoordinate2D){
        let marker = GMSMarker(position: location)
        marker.icon = UIImage(named: "destination")
        marker.title = "Destination"
        marker.map = MapView
    }
    
    func setPaymentMethod(){
        if(defaultPayment == nil){
            paymentIcon.image = UIImage(named: "money")
            paymentLabel.text = "Cash"
        } else {
            paymentIcon.image = defaultPayment.image
            paymentLabel.text = defaultPayment.cardNumber
        }
    }
    
    func setupRideList(){
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        rideListCardViewController = RideListCardViewController(nibName: "RideListCardViewController", bundle: nil)
        
        self.addChild(rideListCardViewController)
        self.view.addSubview(rideListCardViewController.view)
        self.view.addSubview(optionsView)
        self.view.addSubview(blackView)
        self.view.addSubview(sortPicker)
        self.view.addSubview(toolBar)
        sortPicker.delegate = self
        sortPicker.isHidden = true
        toolBar.isHidden = true
        
        rideListCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - collapsedShowableRegion, width: self.view.bounds.width, height: collapsedRideListHeight)
        rideListCardViewController.view.clipsToBounds = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handPaymentTap(recognizer:)))
        rideListCardViewController.rideListDelegate = self
        rideListCardViewController.sortDelegate = self
        rideListCardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        paymentView.addGestureRecognizer(tapGesture)
        paymentView.isUserInteractionEnabled = true
    }
    
    
    @IBAction func requestTapped(_ sender: Any) {
        if(nowSelected == true){
            performSegue(withIdentifier: "toRequestedRide", sender: self)
        } else {
            let desLoc = Location(lat: destinationLat, lng: destinationLong, address: destinationName)
            let originLoc = Location(lat: originLat, lng: originLong, address: originName)
            let apiInput = RideInput(rideType: RideTypeEnum(rawValue: rideListCardViewController.selectedRide.rideType), seats: String(passengerCount), walkingDistance: String(selectedDistance), userId: "123", originLocation: originLoc, destination: desLoc)
            UserAPI.scheduleRidePost(body: apiInput) { (ScheduledRideRequest, Error) in
                let status = ScheduledRideRequest!.status!
                switch(status){
                    case RideStatusEnum.scheduled:
                        var origin = ""
                        var destination = destinationName.split(separator: ",")
                        if(originName == "Current Location"){
                            origin = "Ponttor"
                        } else {
                            origin = originName
                        }

                        let trip = Trips(passengers: String(passengerCount), origin: origin, destination: String(destination[0]), date: self.scheduleDate, walkingDistance: String(selectedDistance), daysStack: [], latOrigin: originLat, longOrigin: originLong, latDestination: destinationLat, longDestination: destinationLong, rideType: selectedRideType)
                        scheduledTrips.append(trip)
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
                        self.performSegue(withIdentifier: "toScheduledRide", sender: self)
                    default:
                    print("default")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toRequestedRide"){
            if let vc = segue.destination as? RequestedRideViewController {
               vc.rideType = RideTypeEnum(rawValue: rideListCardViewController.selectedRide.rideType)
            }
        } 
    }
    @IBAction func doneTapped(_ sender: Any) {
        switch(selectedSortOption){
            case "Price: Low-High":
                rideListCardViewController.rides.sort { (first: Ride, second:Ride) -> Bool in
                    return first.price < second.price}
            case "Pickup Time: Earliest-Latest":
                rideListCardViewController.rides.sort { (first: Ride, second:Ride) -> Bool in
                    return first.pickupTime < second.pickupTime}
            case "Pickup Time: Latest-Earliest":
                rideListCardViewController.rides.sort { (first: Ride, second:Ride) -> Bool in
                    return first.pickupTime > second.pickupTime}
            case "ETA: Earliest-Latest":
                rideListCardViewController.rides.sort { (first: Ride, second:Ride) -> Bool in
                    return first.eta < second.eta}
            case "ETA: Latest-Earliest":
                rideListCardViewController.rides.sort { (first: Ride, second:Ride) -> Bool in
                    return first.eta > second.eta}
            default:
                rideListCardViewController.rides.sort { (first: Ride, second:Ride) -> Bool in
                    return first.price<second.price
                }
            }
       
       rideListCardViewController.rideTypeTableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.sortPicker.frame = CGRect(x: 0, y: self.view.frame.height, width: self.sortPicker.frame.width, height: self.sortPicker.frame.height)
            self.toolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.toolBar.frame.width, height: self.toolBar.frame.height)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.sortPicker.frame = CGRect(x: 0, y: self.view.frame.height, width: self.sortPicker.frame.width, height: self.sortPicker.frame.height)
            self.toolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.toolBar.frame.width, height: self.toolBar.frame.height)
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
   
    
    @objc
    func handPaymentTap(recognizer: UITapGestureRecognizer){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.paymentsViewController) as? AddPaymentsViewController{
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc
    func handCardTap(recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: rideListCardViewController.handleArea)
            var fractionComplete = translation.y / expandedRideListHeight
            fractionComplete = isListExpanded ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded (state:RideListState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.rideListCardViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.expandedRideListHeight )
                    self.optionsView.isHidden = true
                case .collapsed:
                    self.rideListCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - self.collapsedShowableRegion, width: self.view.bounds.width, height: self.collapsedRideListHeight)
                    self.optionsView.isHidden = false
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.isListExpanded = !self.isListExpanded
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.rideListCardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.rideListCardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:RideListState, duration:TimeInterval) {
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
    
    func viewSortOptions(){
        sortPicker.isHidden = false
        toolBar.isHidden = false
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        blackView.frame = view.frame
        blackView.alpha = 0
        sortPicker.frame = CGRect(x: 0, y: self.view.frame.height, width: sortPicker.frame.width, height: sortPicker.frame.height)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: toolBar.frame.width, height: toolBar.frame.height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.sortPicker.frame = CGRect(x: 0, y: self.view.frame.height - self.sortPicker.frame.height, width: self.sortPicker.frame.width, height: self.sortPicker.frame.height)
            
            self.toolBar.frame = CGRect(x: 0, y: self.view.frame.height - self.sortPicker.frame.height, width: self.toolBar.frame.width, height: self.toolBar.frame.height)
           
        }
    }
   
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.sortPicker.frame = CGRect(x: 0, y: self.view.frame.height, width: self.sortPicker.frame.width, height: self.sortPicker.frame.height)
            self.toolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.toolBar.frame.width, height: self.toolBar.frame.height)
        }
    }
}

extension RideSelectionViewController: RideListProtocol{
    func selectedRide(selectedRide: String) {
        selectedRideType = selectedRide
    }
    
    func collapseList() {
        if(isListExpanded == true){
            animateTransitionIfNeeded (state:nextState, duration:0.9)
        }
    }
}

extension RideSelectionViewController: SortProtocol{
    func sortRideList() {
        viewSortOptions()
    }
}

extension RideSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return sortOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedSortOption = sortOptions[row]
    }
}

