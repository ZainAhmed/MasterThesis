//
//  EditNameViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 09.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import TextFieldEffects

class EditNameViewController: UIViewController {

    @IBOutlet weak var firstName: HoshiTextField!
    @IBOutlet weak var lastName: HoshiTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    func setupElements(){
        Utilities.styleTextField(firstName)
        Utilities.styleTextField(lastName)
        firstName.text = firstNameGlobal
        
        if(lastNameGlobal != nil){
            lastName.text = lastNameGlobal
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
  
    @IBAction func lastNameTapped(_ sender: Any) {
        lastNameGlobal = lastName.text
    }
    @IBAction func firstNameTapped(_ sender: Any) {
        firstNameGlobal = firstName.text
    }
}
