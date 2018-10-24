//
//  DJITimelineYawEvent.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/18.
//  Copyright © 2018 kiwi. All rights reserved.
//

import Foundation
import PromiseKit
import DJISDK

public struct DJITimelineAircraftYawEvent: DJITimelineEvent {
    
    private(set) public var controlData: DJIVirtualStickFlightControlData
    
    public init(yaw: Float) {
        self.controlData = DJIVirtualStickFlightControlData(pitch: 0, roll: 0, yaw: yaw, verticalThrottle: 0)
    }
    
    public func start() -> Promise<Void> {
       guard let flightController = DJISDKManager.aircraft?.flightController,
             flightController.isVirtualStickControlModeAvailable() else {
            return Promise(error: DJITimelineMissionError.aircraftStateError("can't send flight control"))
        }
        let attitudekey = DJIFlightControllerKey(param: DJIFlightControllerParamAttitude)!
        guard let attitudeValue = DJISDKManager.keyManager()?.getValueFor(attitudekey)?.value,
              let originYaw = (attitudeValue as? DJISDKVector3D)?.z else {
                return Promise(error: DJITimelineMissionError.aircraftStateError("Get current yaw value failed"))
        }
        return Promise { seal in
            var timeoutCount = 0
            func sendControlData() {
                flightController.send(controlData) { error in
                    if let error = error {
                        return seal.reject(error)
                    } else {
                        guard let attitudeValue = DJISDKManager.keyManager()?.getValueFor(attitudekey)?.value,
                            let currentYaw = (attitudeValue as? DJISDKVector3D)?.z else {
                                return seal.reject(DJITimelineMissionError.aircraftStateError("Get current yaw value failed"))
                        }
                        if fabs(currentYaw - originYaw) > 1 { //确定飞机执行旋转指令之后才进行下一步，否则0.1秒后重新发送指令
                            seal.fulfill(())
                        } else {
                            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                timeoutCount += 1
                                if timeoutCount > 15 {
                                    seal.reject(DJITimelineMissionError.aircraftStateError("change aircraft yaw timeout"))
                                } else {
                                    sendControlData()
                                }
                            })
                        }
                    }
                }
            }
            sendControlData()
        }
    }
    
}
