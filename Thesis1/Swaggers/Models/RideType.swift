//
// RideType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct RideType: Codable {


    public var rideType: RideTypeEnum?

    /** Name of the vehicle type displayed on the application */
    public var displayName: String?

    /** The cost of the trip */
    public var price: Double?

    /** Estimated Time of Pickup */
    public var pickup: String?

    /** Estimated Time the ride will arrive at the user&#x27;s drop off destination */
    public var eta: String?
    public init(rideType: RideTypeEnum? = nil, displayName: String? = nil, price: Double? = nil, pickup: String? = nil, eta: String? = nil) { 
        self.rideType = rideType
        self.displayName = displayName
        self.price = price
        self.pickup = pickup
        self.eta = eta
    }
    public enum CodingKeys: String, CodingKey { 
        case rideType = "ride_type"
        case displayName
        case price
        case pickup
        case eta
    }

}