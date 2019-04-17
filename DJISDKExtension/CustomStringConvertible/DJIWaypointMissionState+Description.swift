//
//  DJIWaypointMissionState+Description.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/1/9.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

extension DJIWaypointMissionState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .disconnected:
            return "disconnected"
        case .executing:
            return "executing"
        case .executionPaused:
            return "executionPaused"
        case .notSupported:
            return "notSupported"
        case .readyToExecute:
            return "readyToExecute"
        case .readyToUpload:
            return "readyToUpload"
        case .recovering:
            return "recovering"
        case .uploading:
            return "uploading"
        @unknown default:
            return "unknown"
        }
    }
}
