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
    
}

extension DJIHotpointMissionOperator: DJIMissionOperator {
    
}

extension DJIFollowMeMissionOperator: DJIMissionOperator {
    
}

extension DJITapFlyMissionOperator: DJIMissionOperator {
    public func stopMission(completion: DJICompletionBlock?) {
        stopMissionWtihCompletion(completion)
    }
}

extension DJIPanoramaMissionOperator: DJIMissionOperator {
    
}

extension DJIIntelligentHotpointMissionOperator: DJIMissionOperator {
    
}

extension DJIActiveTrackMissionOperator: DJIMissionOperator {
    
}
