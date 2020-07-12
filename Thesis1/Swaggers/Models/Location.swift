//
// Location.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct Location: Codable {


    /** The latitude component of a location */
    public var lat: Double?

    /** The longitude component of a location */
    public var lng: Double?

    /** A human readable address at/near the given location */
    public var address: String?
    public init(lat: Double? = nil, lng: Double? = nil, address: String? = nil) { 
        self.lat = lat
        self.lng = lng
        self.address = address
    }

}