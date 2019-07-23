//
//  DJIMissionOperator.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/2/20.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

public protocol DJIMissionOperator: class {
    func stopMission(completion: DJICompletionBlock?)
}

extension DJIMissionOperator {
    public func stopMission() -> Promise<Void> {
        return Promise { seal in
            stopMission(completion: seal.resolve)
        }
    }
}

extension DJIWaypointMissionOperator: DJIMissionOperator {
    public func pauseMission() -> Promise<Void> {
        return Promise { seal in
            pauseMission(completion: seal.resolve)
        }
    }
    
    public func resumeMission() -> Promise<Void> {
        return Promise { seal in
            resumeMission(completion: seal.resolve)
        }
    }
}

extension DJIHotpointMissionOperator: DJIMissionOperator {
    public func startMission(_ mission: DJIHotpointMission) -> Promise<Void> {
        return Promise { seal in
            start(mission, withCompletion: seal.resolve)
        }
    }
    
    public func pauseMission() -> Promise<Void> {
        return Promise { seal in
            pauseMission(completion: seal.resolve)
        }
    }

    public func resumeMission() -> Promise<Void> {
        return Promise { seal in
            resumeMission(completion: seal.resolve)
        }
    }
}

extension DJIFollowMeMissionOperator: DJIMissionOperator {
    
}

extension DJITapFlyMissionOperator: DJIMissionOperator {
    
}

extension DJIPanoramaMissionOperator: DJIMissionOperator {
    
}

extension DJIIntelligentHotpointMissionOperator: DJIMissionOperator {
    
}

extension DJIActiveTrackMissionOperator: DJIMissionOperator {
    
}
