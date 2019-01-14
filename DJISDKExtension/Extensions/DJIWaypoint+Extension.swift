//
//  WaypointMissionHelper.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/1/14.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

extension DJIWaypoint {
    
    public var location: CLLocation {
       return CLLocation(coordinate: coordinate, altitude: Double(altitude), horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    }
    
    /// two waypoint distance should greater than 0.5m, less than 2000
    public func isInValidDistance(_ waypoint: DJIWaypoint) -> Bool {
        let distance = location.distance(from: waypoint.location)
        if (distance < 0.5 && abs(altitude - waypoint.altitude) < 0.5) || distance > 2000 {
            return false
        }
        return true
    }
}
