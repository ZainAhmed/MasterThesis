//
//  ViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 29.12.19.
//  Copyright © 2019 Zain Sohail. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpElements()
    }

    func setUpElements(){      
        Utilities.styleTextField(phoneNumber)
    }
    
    func createAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        if( phoneNumber.text! == ""){
            createAlert(title: "Error", message: "Phone number is required")
        } else {
            phoneNo = phoneNumber.text!
            performSegue(withIdentifier: "toVerification", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VerificationViewController
        vc.enteredNumber = phoneNo
    }
}

