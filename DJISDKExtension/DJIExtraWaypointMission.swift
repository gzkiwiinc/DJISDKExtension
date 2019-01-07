//
//  ExtraWayPointMission.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/1/7.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

/// Waypoint mission with no limit waypoints
public class DJIExtraWaypointMission: DJIMission {
    
    var configuredMission: DJIWaypointMission
    let orignalWaypoints: [DJIWaypoint]
    public let waypointMissions: [DJIWaypointMission]
    
    ///  Initialize a `DJIExtraWaypointMission` by copying the parameters from the input mission.
    public init(mission: DJIWaypointMission, waypoints: [DJIWaypoint]) throws {
        configuredMission = mission
        if let error = mission.checkParameters() {
            throw error
        }
        orignalWaypoints = waypoints
        let groupedWaypoints = DJIExtraWaypointMission.groupWaypoints(waypoints)
        waypointMissions = groupedWaypoints.map { (waypoints) -> DJIWaypointMission in
            let waypointMission = DJIMutableWaypointMission(mission: mission)
            waypointMission.removeAllWaypoints()
            waypointMission.addWaypoints(waypoints)
            return waypointMission
        }
        try waypointMissions.forEach {
            if let error = $0.checkValidity() {
                throw error
            }
        }
        super.init()
    }
    
    static func groupWaypoints(_ waypoints: [DJIWaypoint]) -> [[DJIWaypoint]] {
        let waypointMaxSize = 99
        let groupCount = Int(ceil(Float(waypoints.count)/Float(waypointMaxSize)))
        var waypointsGroup = [[DJIWaypoint]]()
        for _ in 0 ..< groupCount {
            if waypoints.count == 100 { // 99 + 1, waypoints should at least 2
                let groupWaypoints = waypoints.dropFirst(98)
                waypointsGroup.append(Array(groupWaypoints))
            } else {
                let groupWaypoints = waypoints.dropFirst(waypointMaxSize)
                waypointsGroup.append(Array(groupWaypoints))
            }
        }
        return waypointsGroup
    }
}
