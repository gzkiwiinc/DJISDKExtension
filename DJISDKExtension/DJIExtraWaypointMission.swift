//
//  ExtraWayPointMission.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/1/7.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

public protocol DJIExtraWaypointMissionDelegate: class {

}

public enum DJIExtraWaypointMissionError: Error {
    case getMissionOperatorFailed
}

/// Waypoint mission with no limit waypoints
public class DJIExtraWaypointMission: DJIMission {
    
    public weak var delegate: DJIExtraWaypointMissionDelegate?
    
    var configuredMission: DJIWaypointMission
    let orignalWaypoints: [DJIWaypoint]
    public let waypointMissions: [DJIWaypointMission]
    
    var waypointIndex = 0
    var missionIndex = 0
    
    private let listenerQueue = DispatchQueue(label: "com.kiwiinc.MissionListenerQueue")
    
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
    
    public func startMission() -> Promise<Void> {
        waypointIndex = 0
        missionIndex = 0
        return startExecute(mission: waypointMissions[0])
    }
    
    func startExecute(mission: DJIWaypointMission) -> Promise<Void> {
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        if let loadError = missionOperator.load(mission) {
            return Promise(error: loadError)
        }
        return Promise {
            missionOperator.uploadMission(completion: $0.resolve)
        }.then {
            self.missionIsReadyToExecute(missionOperator)
        }.then {
            Promise {
                missionOperator.startMission(completion: $0.resolve)
            }
        }
    }
    
    private func missionIsReadyToExecute(_ missionOperator: DJIWaypointMissionOperator) -> Promise<Void> {
        missionOperator.removeListener(ofUploadEvents: self)
        return Promise { seal in
            missionOperator.addListener(toUploadEvent: self, with: listenerQueue) { (uploadEvent) in
                if uploadEvent.currentState == .readyToExecute {
                    seal.fulfill()
                    missionOperator.removeListener(ofUploadEvents: self)
                }
            }
        }
    }
    
    deinit {
        if let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() {
            missionOperator.removeListener(ofUploadEvents: self)
        }
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
