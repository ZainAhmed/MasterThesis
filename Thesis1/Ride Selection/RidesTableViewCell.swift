//
//  RidesTableViewCell.swift
//  Thesis1
//
//  Created by Zain Sohail on 09.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class RidesTableViewCell: UITableViewCell {

    var rideImageView = UIImageView()
    var rideTitleLabel = UILabel()
    var ridePriceLabel = UILabel()
    var rideEtaLabel = UILabel()
    var ridePickupLabel = UILabel()
    let selectionView = UIView()
    var priceLabel = UILabel()
    var pickupLabel = UILabel()
    var etaLabel = UILabel()
    
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
//    let yellow = UIColor(red: 0/255.0, green: 121/255.0, blue: 164.0/255.0, alpha: 1.0)
    
    let selectionBlue = UIColor(red: 0/255.0, green: 115/255.0, blue: 156.0/255.0, alpha: 1.0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionView.layer.cornerRadius = 6;
        selectionView.layer.masksToBounds = true;
        selectionView.layer.borderWidth = 3
        selectionView.layer.borderColor = selectionBlue.cgColor
        if(nowSelected == false){
            
            ridePriceLabel.isHidden = true
            ridePickupLabel.isHidden = true
            rideEtaLabel.isHidden = true
            priceLabel.isHidden = true
            pickupLabel.isHidden = true
            etaLabel.isHidden = true
        }
        
        self.selectedBackgroundView = selectionView
        
        addSubview(rideImageView)
        addSubview(rideTitleLabel)
        addSubview(ridePriceLabel)
        addSubview(ridePickupLabel)
        addSubview(rideEtaLabel)
        addSubview(priceLabel)
        addSubview(pickupLabel)
        addSubview(etaLabel)
        
        configureImageRideView()
        configureTitleRideLabel()
        
        configureInformationLabel(lbl: ridePriceLabel)
        configureInformationLabel(lbl: rideEtaLabel)
        configureInformationLabel(lbl: ridePickupLabel)
        configureInformationLabel(lbl: priceLabel)
        configureInformationLabel(lbl: pickupLabel)
        configureInformationLabel(lbl: etaLabel)
        
        setImageRideConstraints()
        setTitleRideConstraints()
        setPriceRideConstraints()
        setEtaRideConstraints()
        setPickupRideConstraints()
        setPriceConstraints()
        setPickupConstraints()
        setEtaConstraints()
        
      
    }
    
    func set(ride: Ride){
        rideImageView.image = ride.image
        rideTitleLabel.text = ride.rideType
        ridePriceLabel.text = "€ "+String(ride.price)
        ridePickupLabel.text = ride.pickupTime
        rideEtaLabel.text = ride.eta
        priceLabel.text = "Price:"
        pickupLabel.text = "Pickup:"
        etaLabel.text = "ETA:"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configureImageRideView(){
        rideImageView.layer.cornerRadius = 10
        rideImageView.clipsToBounds = true
    }
    
    func configureTitleRideLabel(){
        rideTitleLabel.numberOfLines = 0
        rideTitleLabel.adjustsFontSizeToFitWidth = true
        rideTitleLabel.font = rideTitleLabel.font.withSize(18)
        rideTitleLabel.textColor =  blue
    }
    func configureInformationLabel(lbl: UILabel){
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = rideTitleLabel.font.withSize(14)
        lbl.textColor =  blue
    }
    
    func setImageRideConstraints(){
        rideImageView.translatesAutoresizingMaskIntoConstraints = false
        rideImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rideImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        rideImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        rideImageView.widthAnchor.constraint(equalTo: rideImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setTitleRideConstraints(){
        rideTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rideTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        rideTitleLabel.leadingAnchor.constraint(equalTo: rideImageView.trailingAnchor, constant: 20).isActive = true
    }
    
    func setPriceRideConstraints(){
        ridePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        ridePriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        ridePriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    }
    
    func setPriceConstraints(){
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: rideImageView.trailingAnchor, constant: 20).isActive = true
    }
    
    func setEtaRideConstraints(){
        rideEtaLabel.translatesAutoresizingMaskIntoConstraints = false
        rideEtaLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55).isActive = true
        rideEtaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    }
    func setEtaConstraints(){
        etaLabel.translatesAutoresizingMaskIntoConstraints = false
        etaLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55).isActive = true
        etaLabel.leadingAnchor.constraint(equalTo: rideImageView.trailingAnchor, constant: 20).isActive = true
    }
    
    func setPickupConstraints(){
        pickupLabel.translatesAutoresizingMaskIntoConstraints = false
        pickupLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        pickupLabel.leadingAnchor.constraint(equalTo: rideImageView.trailingAnchor, constant: 20).isActive = true
    }
    func setPickupRideConstraints(){
        ridePickupLabel.translatesAutoresizingMaskIntoConstraints = false
        ridePickupLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        ridePickupLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    }
}
