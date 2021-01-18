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

public struct DJIGimbalRotateEvent: DJITimelineEvent, CustomDebugStringConvertible {
    
    private(set) public var rotation: DJIGimbalRotation
    
    public init(rotation: DJIGimbalRotation) {
        self.rotation = rotation
    }
    
    public init(pitch: Float) {
        let rotation = DJIGimbalRotation(pitchValue: NSNumber(value: pitch), rollValue: nil, yawValue: nil, time: 0.5, mode: .absoluteAngle, ignore: true)
        self.rotation = rotation
    }
    
    public func start() -> Promise<Void> {
        guard let gimbal = DJISDKManager.aircraft?.gimbal else {
            return Promise(error: DJITimelineMissionError.aircraftStateError("Can't get gimbal state"))
        }
        return Promise { seal in
            var timeoutCount = 0
            func rotateGimbalAction() {
                gimbal.rotate(with: rotation, completion: { (error) in
                    guard error == nil else { return seal.reject(error!) }
                    // After the successful execution of the gimbal command, the Angle check is carried out after a delay of some time (The delay time includes the time for the gimbal to rotate and 0.5s program delay)
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + self.rotation.time + 0.5) {
                        guard let attitude =  gimbal.gimbalAttitude else {
                            return seal.reject(DJITimelineMissionError.aircraftStateError("Get current gimbal pitch value failed"))
                        }
                        let currentGimbalPitch = Double(attitude.pitch)
                        let diff = abs(currentGimbalPitch - Double(truncating: self.rotation.pitch ?? 0))
                        if diff <= 1 {
                            // the diff less than or equal to 1° means successful rotate to the specific angle
                            seal.fulfill(())
                        } else {
                            timeoutCount += 1
                            // A total of five times to retry
                            guard timeoutCount < 5 else { return seal.reject(DJITimelineMissionError.aircraftStateError("Change Gimbal Pinch timeout")) }
                            rotateGimbalAction()
                        }
                    }
                })
            }
            rotateGimbalAction()
        }
    }
    
    public var debugDescription: String {
        return "DJIGimbalRotateEvent: pitch: \(rotation.pitch?.doubleValue ?? 0)"
    }
}
