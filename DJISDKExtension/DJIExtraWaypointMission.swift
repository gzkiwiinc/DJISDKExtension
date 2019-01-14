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
    /// mission start executing or resume exectuting
    func waypointMissionStartExecuting(_ mission: DJIWaypointMission, missionIndex: Int)
    func waypointMissionDidStop(_ mission: DJIWaypointMission, error: Error?)
    func waypointMissionDidPaused(_ mission: DJIWaypointMission)
    func waypointMissionDidFinished()
    func waypointMissionExecuting(_ mission: DJIWaypointMission, executionEvent: DJIWaypointMissionExecutionEvent)
}

public enum DJIExtraWaypointMissionError: Error {
    case getMissionOperatorFailed
    /// mission can't stop or pause in preparing
    case missionIsPreparing
    /// waypoint count is less than 2
    case waypointCountInvalid
    case waypointDistanceInvalid(Int)
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
    public var targetWaypointIndex: Int {
        var totalIndex = 0
        for i in 0 ..< currentMissionIndex {
            totalIndex += Int(waypointMissions[i].waypointCount)
        }
        return totalIndex + currentWaypointIndexInMission
    }
    
    /// if mission is prepareing(uploading wayoint), at this moment mission can't be paused, stop
    public var isMissionPrepareStarting = false
    
    private let listenerQueue = DispatchQueue(label: "com.kiwiinc.MissionListenerQueue")
    
    ///  Initialize a `DJIExtraWaypointMission` by copying the parameters from the input mission.
    public init(mission: DJIWaypointMission, waypoints: [DJIWaypoint]) throws {
        configuredMission = mission
        orignalWaypoints = waypoints
        guard waypoints.count > 1 else {
            throw DJIExtraWaypointMissionError.waypointCountInvalid
        }
        for i in 1 ..< waypoints.count {
            let currentWaypoint = waypoints[i]
            let preWaypoint = waypoints[i-1]
            if preWaypoint.isInValidDistance(currentWaypoint) == false {
                throw DJIExtraWaypointMissionError.waypointDistanceInvalid(i)
            }
        }
        
        let groupedWaypoints = DJIExtraWaypointMission.groupWaypoints(waypoints)
        var missions: [DJIWaypointMission] = []
        for (i,waypoints) in groupedWaypoints.enumerated() {
            let waypointMission = DJIMutableWaypointMission(mission: mission)
            waypointMission.removeAllWaypoints()
            waypointMission.addWaypoints(waypoints)
            
            if i != groupedWaypoints.count - 1 { // only last waypoint mission finishedAction is valid
                waypointMission.finishedAction = .noAction
            } else if i == groupedWaypoints.count - 1 {
                if waypointMission.finishedAction == .goFirstWaypoint {
                    waypointMission.finishedAction = .noAction
                    waypointMission.add(orignalWaypoints[0]) // add first waypoint to the end
                }
            }
            missions.append(waypointMission)
        }
        waypointMissions = missions
        try waypointMissions.forEach {
            if let error = $0.checkValidity() {
                throw error
            }
            if let error = $0.checkParameters() {
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
        isMissionPrepareStarting = false
        DJISDKManager.missionControl()?.waypointMissionOperator().removeListener(self)
        missionOperator.addListener(toExecutionEvent: self, with: listenerQueue) { [weak self] (executionEvent) in
            guard let self = self else { return }
            self.delegate?.waypointMissionExecuting(self.currentMission, executionEvent: executionEvent)
            if let targetWaypointIndex = executionEvent.progress?.targetWaypointIndex
                 , self.currentWaypointIndexInMission < targetWaypointIndex { // if finishAction is goFirstWaypoint, targetIndex will set 0
                self.currentWaypointIndexInMission = targetWaypointIndex
            }
            if executionEvent.currentState == .executionPaused {
                self.delegate?.waypointMissionDidPaused(self.currentMission)
            } else if executionEvent.currentState == .executing {
                self.isMissionPrepareStarting = false
                self.delegate?.waypointMissionStartExecuting(self.currentMission, missionIndex: self.currentMissionIndex)
            }
        }
        missionOperator.addListener(toFinished: self, with: listenerQueue) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.waypointMissionDidStop(self.currentMission, error: error)
                DJISDKManager.missionControl()?.waypointMissionOperator().removeListener(self)
            } else if self.currentWaypointIndexInMission == self.currentMission.waypointCount - 1,
                    let distance = self.distanceFromEndPoint(),
                    distance < 5 { // is stop at last waypoint
                self.missionFinished()
            } else {
                // user trigger goHome, waypoint mission stopped
                self.delegate?.waypointMissionDidStop(self.currentMission, error: nil)
                DJISDKManager.missionControl()?.waypointMissionOperator().removeListener(self)
            }
        }
        return startExecute(mission: waypointMissions[0])
    }
    
    // Distance between current location and endpoint location in meters
    private func distanceFromEndPoint() -> Double? {
        guard let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation),
            let value = DJISDKManager.keyManager()?.getValueFor(locationKey),
            let aircraftLocation = value.value as? CLLocation else {
                return nil
        }
        guard let lastWaypoint = orignalWaypoints.last else { return nil }
        return aircraftLocation.distance(from: lastWaypoint.location)
    }
    
    func startExecute(mission: DJIWaypointMission) -> Promise<Void> {
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        if let loadError = missionOperator.load(mission) {
            return Promise(error: loadError)
        }
        delegate?.waypointMissionPrepareStart(mission)
        isMissionPrepareStarting = true
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
    
    public func pauseMission() -> Promise<Void> {
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        guard isMissionPrepareStarting == false else {
            return Promise(error: DJIExtraWaypointMissionError.missionIsPreparing)
        }
        return Promise {
            missionOperator.pauseMission(completion: $0.resolve)
        }
    }
    
    public func resumeMission() -> Promise<Void> {
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        return Promise {
            missionOperator.resumeMission(completion: $0.resolve)
        }
    }
    
    public func stopMission() -> Promise<Void> {
        guard let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator() else {
            return Promise(error: DJIExtraWaypointMissionError.getMissionOperatorFailed)
        }
        guard isMissionPrepareStarting == false else {
            return Promise(error: DJIExtraWaypointMissionError.missionIsPreparing)
        }
        return Promise {
            missionOperator.stopMission(completion: $0.resolve)
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
                DJISDKManager.missionControl()?.waypointMissionOperator().removeListener(self)
            }
        }
    }
    
    private func missionIsReadyToExecute(_ missionOperator: DJIWaypointMissionOperator) -> Promise<Void> {
        missionOperator.removeListener(ofUploadEvents: self)
        if missionOperator.currentState == .readyToExecute {
            return Promise.value(())
        }
        return Promise { seal in
            missionOperator.addListener(toUploadEvent: self, with: listenerQueue) { (uploadEvent) in
                print(uploadEvent.currentState)
                if let progress = uploadEvent.progress {
                    print("\(progress.uploadedWaypointIndex)/\(progress.totalWaypointCount)")
                }
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
        let waypointGroupMinSize = 2
        let warningGroupSize = waypointMaxSize + waypointGroupMinSize
        
        let groupCount = Int(ceil(Float(waypoints.count)/Float(waypointMaxSize)))
        var waypointsGroup = [[DJIWaypoint]]()
        var editWaypoints = waypoints.dropFirst(0)
        for i in 0 ..< groupCount {
            if i == (groupCount - 2) && editWaypoints.count < warningGroupSize { // ensure the last group size is equal or greater than min size
                let lastTwoSize = editWaypoints.count - waypointGroupMinSize
                let groupWaypoints = waypoints.prefix(lastTwoSize)
                waypointsGroup.append(Array(groupWaypoints))
                editWaypoints = editWaypoints.dropFirst(lastTwoSize)
            } else {
                let groupWaypoints = editWaypoints.prefix(waypointMaxSize)
                waypointsGroup.append(Array(groupWaypoints))
                editWaypoints = editWaypoints.dropFirst(waypointMaxSize)
            }
        }
        return waypointsGroup
    }
}
