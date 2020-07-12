//
//  PastTrips.swift
//  Thesis1
//
//  Created by Zain Sohail on 03.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import Foundation

struct PastTrips{
    var carType: String!
    var walkingDistanceTxt: String!
    var passengerCountTxt: String!
    var rideStatus: String!
    var dateTxt: Date!
    var costTxt: String!
    var originTxt: String!
    var desTxt: String!
    
    init(carType: String, walkingDistanceTxt: String, passengerCountTxt: String, rideStatus: String, dateTxt: Date, costTxt: String, originTxt: String, desTxt: String) {
        self.carType = carType
        self.walkingDistanceTxt = walkingDistanceTxt
        self.passengerCountTxt = passengerCountTxt
        self.rideStatus = rideStatus
        self.dateTxt = dateTxt
        self.costTxt = costTxt
        self.originTxt = originTxt
        self.desTxt = desTxt
    }
}
