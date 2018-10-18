//
//  DJIGimbalRotateEvent.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/18.
//  Copyright © 2018 kiwi. All rights reserved.
//

import Foundation
import DJISDK
import PromiseKit

public struct DJIGimbalRotateEvent: DJITimelineEvent {
    
    private(set) public var rotation: DJIGimbalRotation
    
    public init(rotation: DJIGimbalRotation) {
        self.rotation = rotation
    }
    
    public init(pitch: Float) {
        let rotation = DJIGimbalRotation(pitchValue: NSNumber(value: pitch), rollValue: nil, yawValue: nil, time: 0, mode: .absoluteAngle)
        self.rotation = rotation
    }
    
    public func start() -> Promise<Void> {
        guard let gimbal = DJISDKManager.aircraft?.gimbal else {
             return Promise(error: DJITimelineMissionError.aircraftStateError("can't get gimbal state"))
        }
        return gimbal.rotate(rotation: rotation)
    }
    
}
