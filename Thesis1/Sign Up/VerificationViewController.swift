//
//  VerificationViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 01.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import UserNotifications
class VerificationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var digitOne: UITextField!
    @IBOutlet weak var digitTwo: UITextField!
    @IBOutlet weak var digitThree: UITextField!
    @IBOutlet weak var digitFour: UITextField!
    @IBOutlet weak var message: UILabel!
    
    private let notificationPublisher = NotificationPublisher()
    var enteredNumber = ""
    var digit1:Int = Int()
    var digit2:Int = Int()
    var digit3:Int = Int()
    var digit4:Int = Int()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        message.text = "Enter the 4 digit verification code sent to you: " + enteredNumber
        
        digitOne.delegate = self
        digitTwo.delegate = self
        digitThree.delegate = self
        digitFour.delegate = self
        
        //setting methods to be called when the value in each field is changed
        digitOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        digitTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        digitThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        digitFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        setUpElements()
    }
  
    func setUpElements(){
        
        Utilities.styleTextField(digitOne)
        Utilities.styleTextField(digitTwo)
        Utilities.styleTextField(digitThree)
        Utilities.styleTextField(digitFour)
        
        digit1 = Int.random(in: 0 ... 10)
        digit2 = Int.random(in: 0 ... 10)
        digit3 = Int.random(in: 0 ... 10)
        digit4 = Int.random(in: 0 ... 10)
        
        // sending a local notification of randomly generated 4 digit code
        notificationPublisher.sendNotification(title: "Verification Code", body: "Your verification is: \(String(describing: digit1))\(String(describing: digit2))\(String(describing: digit3))\(String(describing: digit4))" )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        digitOne.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count==1{
            switch textField{
                case digitOne:
                    digitTwo.becomeFirstResponder()
                case digitTwo:
                    digitThree.becomeFirstResponder()
                case digitThree:
                    digitFour.becomeFirstResponder()
                case digitFour:
                    performSegue(withIdentifier: "toRegisteration", sender: self)
                default:
                    break
            }
        }
    }
    
    @IBAction func resendTapped(_ sender: Any) {
        // resending notification when resend is tapped
        digit1 = Int.random(in: 0 ... 10)
        digit2 = Int.random(in: 0 ... 10)
        digit3 = Int.random(in: 0 ... 10)
        digit4 = Int.random(in: 0 ... 10)
        notificationPublisher.sendNotification(title: "Verification Code", body: "Your verification is: \(String(describing: digit1))\(String(describing: digit2))\(String(describing: digit3))\(String(describing: digit4))" )
    }
    
}
