//
// ScheduledRideRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** Returns the scheduled ride status */
public struct ScheduledRideRequest: Codable {


    public var status: RideStatusEnum?
    public init(status: RideStatusEnum? = nil) { 
        self.status = status
    }

}