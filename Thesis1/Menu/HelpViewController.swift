//
//  HelpViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 14.02.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var helpTableview: UITableView!
    @IBOutlet weak var newsBtn: UIButton!
    @IBOutlet weak var generalBtn: UIButton!
    @IBOutlet weak var journeyBtn: UIButton!
    
    var faqOptions = ["How to add paymen?", "How to cancel the ride?", "Can I pay by cash"]
    
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Help"
        setupElements()
       
    }
    
    func setupElements(){
        helpTableview.delegate = self
        helpTableview.dataSource = self
        helpTableview.register( MenuCell.self, forCellReuseIdentifier: "faqCell")
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        newsBtn.layer.borderWidth = 2
        newsBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        generalBtn.layer.borderWidth = 2
        generalBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        journeyBtn.layer.borderWidth = 2
        journeyBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
    }
    
    
}
extension HelpViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath) as! MenuCell
        cell.textLabel?.text = faqOptions[indexPath.row]
        cell.textLabel?.textColor = blue
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
