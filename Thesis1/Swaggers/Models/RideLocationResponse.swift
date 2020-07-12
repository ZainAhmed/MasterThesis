//
// RideLocationResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** Retuns the ride cancellation status */
public struct RideLocationResponse: Codable {


    /** The latitude component of a location */
    public var lat: Double?

    /** The longitude component of a location */
    public var lng: Double?
    public init(lat: Double? = nil, lng: Double? = nil) { 
        self.lat = lat
        self.lng = lng
    }

}
