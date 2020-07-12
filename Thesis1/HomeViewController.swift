//
//  HomeViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 03.02.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import TextFieldEffects
import WWCalendarTimeSelector

class HomeViewController:   UIViewController,CLLocationManagerDelegate{
    
    @IBOutlet weak var destinationTxt: HoshiTextField!
    @IBOutlet weak var originTxt: HoshiTextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var currentLocation: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    
    let menuLauncher = MenuLauncher()
    let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    let selector = WWCalendarTimeSelector.instantiate()
    let locationManager = CLLocationManager()
    var isDestination = false
    var bounds = GMSCoordinateBounds()
    
    @objc private var dismissViewTap: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation() // call this method for recentering
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Utilities.styleTextField(originTxt)
        Utilities.styleTextField(destinationTxt)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpElements()
    }
    
    func setUpElements(){
        mapView.clear()
        mapView.addSubview(menuView)
        addMarkers()
        
        menuView.layer.cornerRadius = 30
        menuView.clipsToBounds = true
    }
    
    func addMarkers(){
        mapView.clear()
        // set origin marker
        if(originLong != nil && originLat != nil){
            let originPos = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
            let origin = GMSMarker(position: originPos)
            origin.title = "Origin"
            origin.icon = UIImage(named: "origin")
            origin.map = mapView
            originTxt.text = originName
            
            // set destination marker
            if(destinationLat != nil && destinationLong != nil){
                print("inside Destination")
                let desPos = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
                let destination = GMSMarker(position: desPos)
                destination.title = "Destination"
                destination.icon = UIImage(named: "destination")
                destination.map = mapView
                destinationTxt.text = destinationName
                
                // set camera bounds to origin and destination
                bounds = GMSCoordinateBounds(coordinate: origin.position, coordinate: desPos)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
                mapView.animate(with: update) // update the camera to the set bounds
            } else {
                // if user's location not found
                let camera = GMSCameraPosition.camera(withLatitude: (origin.position.latitude),longitude: (origin.position.longitude),zoom: 14)
                mapView.camera = camera
            }
        }
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(findCurrentLocation == true){
            mapView.clear()
            
            // get the location location reveiced by the gps
            let location = locations.last
            locationManager.stopUpdatingLocation()
            
            // setting the origin to Pontwall aachen for prototyping
            originLat = 50.7815908
            originLong = 6.0780325
            originName = "Current Location"
            addMarkers() // adding current location marker
            
            // in real scenarios the co ordinates of the last location recieved would be set as current location
            
            //            if let lat = location?.coordinate.latitude, let long = location?.coordinate.longitude {
            //                originLat = lat
            //                originLong = long
            //                originName = "Current Location"
            //                addMarkers()
            //            }
            findCurrentLocation = false
        }
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        menuLauncher.showMenu()
        menuLauncher.menuDelegate = self
        menuLauncher.profileDelegate = self
    }
    
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        // finding new current location when the current location icon is tapped
        findCurrentLocation = true
        locationManager.startUpdatingLocation()
        self.viewWillAppear(true)
    }
    
    @IBAction func originTapped(_ sender: Any) {
        isDestination = false
        performSegue(withIdentifier: "toAddLocation", sender: self)
    }
    
    @IBAction func destinationTapped(_ sender: Any) {
        isDestination = true
        performSegue(withIdentifier: "toAddLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sending information to MapLocationViewController
        if(segue.identifier == "toAddLocation"){
            if let vc = segue.destination as? MapLocationViewController {
                vc.prevController = "Home"
                
                //  tapped by Origin textfield
                if(isDestination == false){
                    vc.cameFrom = "origin"
                    vc.serachBarText = self.originTxt.text!
                    vc.latitude = originLat
                    vc.longitude = originLong
                } else if(isDestination == true){ // tapped by destination textfield
                    vc.cameFrom = "destination"
                    if(destinationTxt == nil){
                        //  inserting destination for first time
                        vc.serachBarText = ""
                        vc.orgLong = originLong
                        vc.orgLat = originLat
                    } else {
                        // changing already inserted destination
                        vc.serachBarText = self.destinationTxt.text!
                        vc.latitude = destinationLat
                        vc.longitude = destinationLong
                        vc.orgLong = originLong
                        vc.orgLat = originLat
                    }
                }
            }
        }
    }
    
    func createAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if(destinationName == nil){
            createAlert(title: "Error", message: "Destination is required")
        } else {
            performSegue(withIdentifier: "toPreferences", sender: self)
        }
    }
}

extension HomeViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension HomeViewController: MenuToggleProtocol{
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

extension HomeViewController:ProfileToggleProtocol{
    func toggleProfile() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Soryboard.profileViewController) as? ProfileViewController{
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
