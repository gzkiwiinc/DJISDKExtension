//
//  DJIGimbalKeyedValue+Extension.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/2/21.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIGimbal {
    
   public var gimbalAttitude: DJIGimbalAttitude? {
        guard let key = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees)
            , let attitudeValue = DJISDKManager.keyManager()?.getValueFor(key)?.value as? NSValue else {
                return nil
        }
        var attitude = DJIGimbalAttitude(pitch: 0, roll: 0, yaw: 0)
        attitudeValue.getValue(&attitude)
        return attitude
    }
}
