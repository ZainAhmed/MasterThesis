//
//  MapLocationViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 02.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
protocol MapLocationProtocol{
    func setLocation(lat: CLLocationDegrees,long:CLLocationDegrees, locationName: String,cameFrom:String)
}

class MapLocationViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var Map: GMSMapView!
    @IBOutlet weak var originMarker: UIImageView!
    @IBOutlet weak var destinationMarker: UIImageView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var addressTxtField: UITextField!
    
    var cameFrom: String!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var serachBarText:String!
    var prevController: String!
    var orgLat:CLLocationDegrees!
    var orgLong:CLLocationDegrees!
    
    var delegate:MapLocationProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setUpElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpElements(){
        addressTxtField.isUserInteractionEnabled = false
        Map.delegate = self
        Map.clear()
        if(cameFrom == "origin"){
            confirmBtn.setTitle("Confirm Origin", for: UIControl.State.normal)
            destinationMarker.isHidden = true
            originMarker.isHidden = false
        } else if(cameFrom == "destination"){
            confirmBtn.setTitle("Confirm Destination", for: UIControl.State.normal)
            destinationMarker.isHidden = false
            originMarker.isHidden = true
            let originPos = CLLocationCoordinate2D(latitude: orgLat, longitude: orgLong)
            let origin = GMSMarker(position: originPos)
            origin.title = "Origin"
            origin.icon = UIImage(named: "origin")
            origin.map = Map
        }
        if(serachBarText != ""){
            self.addressTxtField.text = serachBarText
        }
        setMap()
    }
    
    func setMap(){
        if(latitude != nil && longitude != nil){
            let camera = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude,zoom: 20)
            Map.camera = camera
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: orgLat,longitude: orgLong,zoom: 20)
            Map.camera = camera
        }
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        if(prevController == "Home"){
            if(addressTxtField.text != nil){
                if(cameFrom == "origin"){
                    originLong = longitude
                    originLat = latitude
                    originName = addressTxtField.text
                } else if(cameFrom == "destination"){
                    destinationLat = latitude
                    destinationLong = longitude
                    destinationName = addressTxtField.text
                }
            }
        } else if(prevController == "TripsTime"){
            print("inside TripsTime")
            if(addressTxtField.text != nil){
                let name = addressTxtField.text?.split(separator: ",")
                if(cameFrom == "origin"){
                    delegate.setLocation(lat: latitude, long: longitude, locationName: String(name![0]), cameFrom: "origin")
                } else if(cameFrom == "destination"){
                    print("inside destination")
                    delegate.setLocation(lat: latitude, long: longitude, locationName: String(name![0]), cameFrom: "destination")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func homeTapped(_ sender: Any) {
        if(homeLat != nil && homeLong != nil){
            latitude = homeLat
            longitude = homeLong
            self.viewWillAppear(true)
        } else {
            createAlert(title: "Error", message:"Home address has not inserted. You can insert it on the profile screen")
        }
    }
    
    @IBAction func workTapped(_ sender: Any) {
        if(workLat != nil  && workLong != nil){
            latitude = workLat
            longitude = workLong
            self.viewWillAppear(true)
        } else {
             createAlert(title: "Error", message:"Work address has not inserted. You can insert it on the profile screen")
        }
    }
    
    @IBAction func textfieldTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
    
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                UInt(GMSPlaceField.placeID.rawValue))!
            autocompleteController.placeFields = fields
    
            // Specify a filter.
            let filter = GMSAutocompleteFilter()
            filter.type = .noFilter
            autocompleteController.autocompleteFilter = filter
    
            // Display the autocomplete view controller.
                present(autocompleteController, animated: true, completion: nil)
    }
    func createAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
   
}

extension MapLocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        print(position.bearing)
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            //
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        if let lines = place.lines {
                            self.addressTxtField.text = lines[0]
                        }
                    }
                }
            }
        }
    }
}


extension MapLocationViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
     
        dismiss(animated: true, completion: nil)
        let url = "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=" + place.placeID! + "&key=AIzaSyCp-QP1CdC6nouIcoIAoYnAQMkj10IaXQA"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let lat = json["result"]["geometry"]["location"]["lat"].doubleValue
                    let lng = json["result"]["geometry"]["location"]["lng"].doubleValue
                    if(self.latitude != CLLocationDegrees(exactly: lat) && self.longitude !=  CLLocationDegrees(exactly: lng)){
                        self.latitude = CLLocationDegrees(exactly: lat)
                        self.longitude = CLLocationDegrees(exactly: lng)
                        self.setMap()
                    }
                
                case .failure(let error):
                    print("Request failed with error: \(error)")
            }
            
        }
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


