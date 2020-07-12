//
//  MenuLauncher.swift
//  Thesis1
//
//  Created by Zain Sohail on 08.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
protocol MenuToggleProtocol {
    func toggleMenu(menuName: String)
}
protocol ProfileToggleProtocol {
    func toggleProfile()
}
class MenuLauncher:NSObject{
    
    let blackView = UIView()
    let topContainer = UIView(frame: .zero)
    let menuTableView = UITableView()
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    var menuOptions = ["Payments", "Trips", "Help"]
    var menuDelegate: MenuToggleProtocol!
    var profileDelegate:ProfileToggleProtocol!
    let collectionVC : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
 
    
    func showMenu(){
        createMenu()
        
        //show Menu
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            self.blackView.addGestureRecognizer(tapGesture)
            
            window.addSubview(blackView)
            window.addSubview(collectionVC)
            
            let menuWidth: CGFloat = 250
            let menuHeight = window.frame.height
            self.collectionVC.frame = CGRect(x:-menuWidth, y: 0, width: menuWidth, height: menuHeight)
            blackView.frame = window.frame
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionVC.frame = CGRect(x: 0, y: 0, width: self.collectionVC.frame.width, height: self.collectionVC.frame.height)
            }, completion: nil)
        }
    }
    
   
    
  
    
    func createMenu(){
        topContainer.backgroundColor = blue
        collectionVC.addSubview(topContainer)
        topContainer.frame = CGRect(x: 0, y: 0, width: 250, height: 210)
     
        menuTableView.frame = CGRect(x: 0, y: 210, width: 250, height:210)
        menuTableView.separatorInset.right = 15
        menuTableView.separatorInset.left = 15
        collectionVC.addSubview(menuTableView)
        
        let profileBtn = UIButton()
        profileBtn.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        profileBtn.setImage(UIImage(named: "baseline_account_circle_white_48pt_2x"), for: UIControl.State.normal)
        profileBtn.addTarget(self, action: #selector(profileBtnTapped(sender:)), for:.touchUpInside)
        topContainer.addSubview(profileBtn)
        profileBtn.translatesAutoresizingMaskIntoConstraints = false
        profileBtn.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        profileBtn.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 55).isActive  = true
        
        let nameLbl = UILabel()
        nameLbl.frame = CGRect(x: 0, y: 0, width: 96, height: 24)
        nameLbl.textColor = .white
        if(lastNameGlobal != nil){
            nameLbl.text = firstNameGlobal + " " + lastNameGlobal
        } else {
            nameLbl.text = firstNameGlobal
        }
        topContainer.addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.centerXAnchor.constraint(equalTo: profileBtn.centerXAnchor).isActive = true
        nameLbl.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -38).isActive  = true
    }
    
    @objc func handleTap(sender : UIView) {
        dismissMenu()
    }
    
    @objc func profileBtnTapped(sender : UIView) {
        dismissMenu()
        profileDelegate.toggleProfile()
    }
    func dismissMenu(){
        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.3){
                self.blackView.alpha = 0
                self.collectionVC.frame = CGRect(x: -250, y: 0, width: 250, height: window.frame.height)
            }
        }
    }
    override init(){
        super.init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register( MenuCell.self, forCellReuseIdentifier: "menuCell")
    }
}

extension MenuLauncher:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.textLabel?.text = menuOptions[indexPath.row]
        cell.textLabel?.textColor = blue
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissMenu()
        menuDelegate.toggleMenu(menuName: menuOptions[indexPath.row])
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

