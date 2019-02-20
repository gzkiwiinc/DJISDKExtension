//
//  DJIMissionControl+Extension.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/2/20.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

extension DJIMissionControl {
    
    public enum DJIMissionOperatorType {
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
    
    public func getStartedOperator() -> DJIMissionOperatorType? {
        if waypointMissionOperator().isStarted {
            return DJIMissionOperatorType.waypointMission
        } else if hotpointMissionOperator().isStarted {
            return DJIMissionOperatorType.hotpointMission
        } else if followMeMissionOperator().isStarted {
            return DJIMissionOperatorType.followMeMission
        } else if activeTrackMissionOperator().isStarted {
            return DJIMissionOperatorType.activeTrackMission
        } else if tapFlyMissionOperator().isStarted {
            return DJIMissionOperatorType.tapFlyMission
        } else if panoramaMissionOperator().isStarted {
            return DJIMissionOperatorType.panoramaMission
        } else if intelligentHotpointMissionOperator().isStarted {
            return DJIMissionOperatorType.intelligentHotpointMission
        } else {
            return nil
        }
    }
    
    public func getOperator(_ missionOperator: DJIMissionOperatorType) -> DJIMissionOperator {
        switch missionOperator {
        case .waypointMission:
            return waypointMissionOperator()
        case .hotpointMission:
            return hotpointMissionOperator()
        case .followMeMission:
            return followMeMissionOperator()
        case .activeTrackMission:
            return activeTrackMissionOperator()
        case .tapFlyMission:
            return tapFlyMissionOperator()
        case .panoramaMission:
            return panoramaMissionOperator()
        case .intelligentHotpointMission:
            return intelligentHotpointMissionOperator()
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
