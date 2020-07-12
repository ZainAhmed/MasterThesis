//
//  PreferencesViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 14.02.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import TextFieldEffects
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var addWork: UITextField!
    @IBOutlet weak var addHome: UITextField!
    @IBOutlet weak var cellNo: HoshiTextField!
    @IBOutlet weak var name: HoshiTextField!
    @IBOutlet weak var wheelChairSwitch: UISwitch!
    
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    
    var isWorkTapped = false
    var isHomeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupElements()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupElements(){
        setNameField()
        setPhoneField()
        setHome()
        setWork()
        wheelChairSwitch.isOn = isWheelChairEnabled
    }
    
    func setNameField(){
        Utilities.styleTextField(name)
        createRightIcon(textField: name, imageName: "icons8-expand-arrow-20")
        if(lastNameGlobal != nil){
            name.text = firstNameGlobal + " " + lastNameGlobal
        } else {
            name.text = firstNameGlobal
        }
    }
    
    func setHome(){
        print(homeLong)
        if(homeLong == nil && homeLat == nil){
            addHome.text = "Add Home"
        } else {
            addHome.text = homeName
        }
        addHome.textColor = blue
        createRightIcon(textField: addHome, imageName: "icons8-expand-arrow-20")
        createLeftIcon(textField: addHome,imageName: "icons8-home-24")
    }
    
    func setWork(){
        if(workLong == nil && workLat == nil){
            addWork.text = "Add Work"
        } else {
            addWork.text = workName
        }
        addWork.textColor = blue
        createRightIcon(textField: addWork, imageName: "icons8-expand-arrow-20")
        createLeftIcon(textField: addWork,imageName: "icons8-business-24")
    }
    func setPhoneField(){
        Utilities.styleTextField(cellNo)
        cellNo.text = phoneNo
    }
    
    func createRightIcon(textField: UITextField,imageName:String){
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = UIImageView(image: UIImage(named: imageName))
    }
    
    func createLeftIcon(textField: UITextField,imageName:String){
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = UIImageView(image: UIImage(named: imageName))
    }
    
   
    @IBAction func isWheelChairSwitchTapped(_ sender: Any) {
         isWheelChairEnabled = wheelChairSwitch.isOn
    }
    
    @IBAction func nameTapped(_ sender: Any) {
        performSegue(withIdentifier: "toNameChange", sender: self)
    }
    
    @IBAction func workTapped(_ sender: Any) {
        isWorkTapped = true
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
    
    @IBAction func homeTapped(_ sender: Any) {
        isHomeTapped = true
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
    
}

extension ProfileViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
        let url = "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=" + place.placeID! + "&key=AIzaSyCp-QP1CdC6nouIcoIAoYnAQMkj10IaXQA"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let lat = json["result"]["geometry"]["location"]["lat"].doubleValue
                let lng = json["result"]["geometry"]["location"]["lng"].doubleValue
                let name = json["result"]["name"].string
                if(self.isWorkTapped == true){
                    workLong = CLLocationDegrees(exactly: lng)
                    workLat = CLLocationDegrees(exactly: lat)
                    workName = name
                    self.setWork()
                }
                if(self.isHomeTapped == true){
                    homeLong = CLLocationDegrees(exactly: lng)
                    homeLat = CLLocationDegrees(exactly: lat)
                    homeName = name
                    self.setHome()
                }
                self.isWorkTapped = false
                self.isHomeTapped = false
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
