//
//  DJIMissionControl+Extension.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/2/20.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

extension DJIMissionControl {
    
    public enum DJIMissionOperator {
        case waypointMission
        case hotpointMission
        case followMeMission
        case activeTrackMission
        case tapFlyMission
        case panoramaMission
        case intelligentHotpointMission
    }
    
    public var isMissionStarted: Bool {
        return getStartedOperator() == nil
    }
    
    public func getStartedOperator() -> DJIMissionOperator? {
        if waypointMissionOperator().isStarted {
            return DJIMissionOperator.waypointMission
        } else if hotpointMissionOperator().isStarted {
            return DJIMissionOperator.hotpointMission
        } else if followMeMissionOperator().isStarted {
            return DJIMissionOperator.followMeMission
        } else if activeTrackMissionOperator().isStarted {
            return DJIMissionOperator.activeTrackMission
        } else if tapFlyMissionOperator().isStarted {
            return DJIMissionOperator.tapFlyMission
        } else if panoramaMissionOperator().isStarted {
            return DJIMissionOperator.panoramaMission
        } else if intelligentHotpointMissionOperator().isStarted {
            return DJIMissionOperator.intelligentHotpointMission
        } else {
            return nil
        }
    }
}

extension DJIWaypointMissionOperator {
    public var isStarted: Bool {
        return currentState == .executing || currentState == .executionPaused
    }
}

extension DJIHotpointMissionOperator {
    public var isStarted: Bool {
        return currentState == .executing || currentState == .executionPaused || currentState == .executingInitialPhase
    }
}

extension DJIFollowMeMissionOperator {
    public var isStarted: Bool {
        return currentState == .executing
    }
}

extension DJIActiveTrackMissionOperator {
    public var isStarted: Bool {
        return currentState == .waitingForConfirmation || currentState == .cannotConfirm
                || currentState == .aircraftFollowing || currentState == .onlyCameraFollowing || currentState == .findingTrackedTarget
    }
}

extension DJITapFlyMissionOperator {
    public var isStarted: Bool {
        return currentState == .executing || currentState == .executionPaused || currentState == .executionResetting
    }
}

extension DJIPanoramaMissionOperator {
    public var isStarted: Bool {
        return currentState == .executing
    }
}

extension DJIIntelligentHotpointMissionOperator {
    public var isStarted: Bool {
        return currentState == .executing || currentState == .executionPaused
    }
}
