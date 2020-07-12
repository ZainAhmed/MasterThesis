//
//  Trips.swift
//  Thesis1
//
//  Created by Zain Sohail on 01.05.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import Foundation
import CoreLocation
struct Trips{
    var passengers: String!
    var origin: String!
    var destination: String!
    var date: Date!
    var walkingDistance: String!
    var daysStack: [String]!
    var latOrigin: CLLocationDegrees!
    var longOrigin: CLLocationDegrees!
    var latDestination: CLLocationDegrees!
    var longDestination:CLLocationDegrees!
    var rideType: String!
    
    init(passengers: String, origin: String, destination: String, date: Date, walkingDistance: String, daysStack:[String], latOrigin:CLLocationDegrees, longOrigin:CLLocationDegrees, latDestination:CLLocationDegrees, longDestination:CLLocationDegrees, rideType: String!) {
        self.passengers = passengers
        self.origin = origin
        self.destination = destination
        self.date = date
        self.walkingDistance = walkingDistance
        self.daysStack = daysStack
        self.latOrigin = latOrigin
        self.longOrigin = longOrigin
        self.latDestination = latDestination
        self.longDestination = longDestination
        self.rideType = rideType
    }
}
