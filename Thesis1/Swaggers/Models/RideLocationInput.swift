//
// RideLocationInput.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct RideLocationInput: Codable {


    /** The ID of the requested ride */
    public var vehicleId: String?
    public init(vehicleId: String? = nil) { 
        self.vehicleId = vehicleId
    }
    public enum CodingKeys: String, CodingKey { 
        case vehicleId = "vehicle_id"
    }

}