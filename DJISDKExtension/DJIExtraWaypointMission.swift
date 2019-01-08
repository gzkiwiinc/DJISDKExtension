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
    func waypointMissionPrepareStart(_ mission: DJIWaypointMission)
    func waypointMissionExecuting(_ mission: DJIWaypointMission, executionEvent: DJIWaypointMissionExecutionEvent)
    func waypointMissionDidStop(_ mission: DJIWaypointMission, error: Error?)
    func waypointMissionDidFinished()
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
    
    var currentWaypointIndexInMission = 0
    var currentMissionIndex = 0
    public var currentMission: DJIWaypointMission {
        return waypointMissions[currentMissionIndex]
    }
    public var currentWaypointIndex: Int {
        var totalIndex = 0
        for i in 0 ..< currentMissionIndex {
            totalIndex += Int(waypointMissions[i].waypointCount)
        }
        return totalIndex + currentWaypointIndexInMission
    }
    
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
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        currentWaypointIndexInMission = 0
        currentMissionIndex = 0
        missionOperator.addListener(toExecutionEvent: self, with: listenerQueue) { [weak self] (executionEvent) in
            guard let self = self else { return }
            self.delegate?.waypointMissionExecuting(self.currentMission, executionEvent: executionEvent)
            if let progress = executionEvent.progress {
                self.currentWaypointIndexInMission = progress.targetWaypointIndex
            }
        }
        missionOperator.addListener(toFinished: self, with: listenerQueue) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.waypointMissionDidStop(self.currentMission, error: error)
            } else if self.currentWaypointIndex == self.currentMission.waypointCount - 1 { // is stop at last waypoint
                self.missionFinished()
            } else {
                // user trigger goHome, waypoint mission stopped
                self.delegate?.waypointMissionDidStop(self.currentMission, error: nil)
            }
        }
        return startExecute(mission: waypointMissions[0])
    }
    
    func startExecute(mission: DJIWaypointMission) -> Promise<Void> {
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        delegate?.waypointMissionPrepareStart(mission)
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
    
    private func missionFinished() {
        if currentMissionIndex == waypointMissions.count - 1 {
            delegate?.waypointMissionDidFinished()
            DJISDKManager.missionControl()?.waypointMissionOperator().removeListener(self)
        } else {
            currentMissionIndex += 1
            currentWaypointIndexInMission = 0
            firstly {
                self.startExecute(mission: currentMission)
            }.catch { (error) in
                self.delegate?.waypointMissionDidStop(self.currentMission, error: error)
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
        DJISDKManager.missionControl()?.waypointMissionOperator().removeListener(self)
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