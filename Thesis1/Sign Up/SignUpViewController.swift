//
//  SignUpViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 12.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import TextFieldEffects


class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wheelChairEnabled: UISwitch!
    @IBOutlet weak var lastName: HoshiTextField!
    @IBOutlet weak var firstName: HoshiTextField!
    @IBOutlet weak var addPayment: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpElements()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
  
    
    func setUpElements(){
//        lastName.delegate = self
        
        Utilities.styleTextField(lastName)
        Utilities.styleTextField(firstName)
        addPayment.layer.borderWidth = 1
        let yellow = UIColor(red: 227.0/255.0, green: 161.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        addPayment.layer.borderColor = yellow.cgColor
        
        if(lastNameGlobal != ""){
            lastName.text = lastNameGlobal
        }
        
        if(firstNameGlobal != ""){
            firstName.text = firstNameGlobal
        }
        if(isWheelChairEnabled != nil){
            wheelChairEnabled.isOn = isWheelChairEnabled
        }
        
        dismiss(animated: true, completion: nil)       
    }
  
    @IBAction func saveTapped(_ sender: Any) {
        
        
        if(firstNameGlobal == nil){
            createAlert(title: "Error", message: "First name is required")
        } else {
            isWheelChairEnabled = wheelChairEnabled.isOn
            let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Soryboard.homeViewController) as? HomeViewController
            
            navigationController?.pushViewController(homeViewController!,animated: true)
            
        }
    }
    
    @IBAction func firstNameTapped(_ sender: Any) {
        firstNameGlobal = firstName.text
    }
    
    @IBAction func lastNameTapped(_ sender: Any) {
        lastNameGlobal = lastName.text
    }
    
    func createAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
}
