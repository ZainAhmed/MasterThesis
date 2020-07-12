//
//  SuccessScheduleViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 01.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class SuccessScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toHomeTapped(_ sender: Any) {
        performSegue(withIdentifier: "schduleToHome", sender: self)
    }
}
