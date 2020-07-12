//
//  MainNavigationController.swift
//  Thesis1
//
//  Created by Zain Sohail on 11.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController :UINavigationController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }
    
    func setupNav(){
        UINavigationBar.appearance().tintColor = UIColor(red: 1/255.0, green: 77/255.0, blue: 103.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 1/255.0, green: 77/255.0, blue: 103.0/255.0, alpha: 1.0)]
    }
}
