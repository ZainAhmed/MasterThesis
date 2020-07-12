//
//  SaveCardViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 18.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
import TextFieldEffects
class SaveCardViewController: UIViewController {

    @IBOutlet weak var cardNumber: HoshiTextField!
    @IBOutlet weak var validity: HoshiTextField!
    @IBOutlet weak var cvv: HoshiTextField!
    var viewParentController : AddPaymentsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpElements()
    }
    func setUpElements(){
        Utilities.styleTextField(cardNumber)
        Utilities.styleTextField(validity)
        Utilities.styleTextField(cvv)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let viewcontroller = viewParentController {
            let suffix = cardNumber.text?.suffix(4)
            viewcontroller.insertSavedPayments(cardEnding: String(suffix!))
            
        }
        self.navigationController?.popViewController(animated: true)
    }
}
