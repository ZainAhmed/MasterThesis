//
//  GlobalVariables.swift
//  Thesis1
//
//  Created by Zain Sohail on 02.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import Foundation
import CoreLocation

var lastNameGlobal: String!
var firstNameGlobal:String!
var isWheelChairEnabled:Bool!
var savedCardsGlobal:[SavedCards]! = []
var cashOptinGlobal:[SavedCards]! = []
var defaultPayment:SavedCards!
var defaultPaymentIndex: Int = -1
var oldDefaultPaymentIndex: Int = -1
var originLat:CLLocationDegrees!
var originLong:CLLocationDegrees!
var originName: String!
var destinationLat:CLLocationDegrees!
var destinationLong:CLLocationDegrees!
var destinationName: String!
var findCurrentLocation = true
var nowSelected = true
var scheduledTime: String!
var dismissNot = false
var selectedDistance: Double = 250;
var passengerCount = 1
var scheduledTrips:[Trips] = []
var pastTrips:[PastTrips] = []
var isSignedUp = false
var selectedRideType:String!
var phoneNo:String!
var homeLat:CLLocationDegrees! = 50.7815908
var homeLong:CLLocationDegrees! = 6.0780325
var homeName: String! = "Ponttwall"
//home
//latitude = CLLocationDegrees(exactly: 50.780182)
//longitude = CLLocationDegrees(exactly: 6.078777)

var workLat:CLLocationDegrees! = 50.774631
var workLong:CLLocationDegrees! = 6.087097
var workName: String! = "Deutsche Bank"
//work
//latitude = CLLocationDegrees(exactly: 50.774631)
//longitude = CLLocationDegrees(exactly: 6.087097)

