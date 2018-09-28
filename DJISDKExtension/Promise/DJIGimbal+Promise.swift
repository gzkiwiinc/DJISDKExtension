//
//  DJIGimbal+Promise.swift
//  PanoramaDemo
//
//  Created by Sunnyyoung on 2017/11/17.
//  Copyright © 2017年 Kiwi Information Technology Co., Ltd. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIGimbal {
    
    /// If PitchRange extended, the gimbal's pitch control range
    /// can be [-30, 90], otherwise, it's [0, 90].
    public func rotate(pitch: Double, time: TimeInterval = 0.0, mode: DJIGimbalRotationMode = .absoluteAngle) -> Promise<Void> {
        return Promise { seal in
            let rotation = DJIGimbalRotation(pitchValue: NSNumber(value: pitch), rollValue: nil, yawValue: nil, time: time, mode: mode)
            self.rotate(with: rotation) { (error) in
                seal.resolve((), error)
            }
        }
    }
    
    /// Resets the gimbal
    public func reset() -> Promise<Void> {
        return Promise { seal in
            self.reset { (error) in
                seal.resolve((), error)
            }
        }
    }
    
    /// Extends the pitch range of gimbal. If extended, the gimbal's pitch control range
    /// can be [-30, 90], otherwise, it's [0, 90].
    public func setPitchRangeExtensionEnabled(_ isEnabled: Bool) -> Promise<Void> {
        return Promise { seal in
            self.setPitchRangeExtensionEnabled(isEnabled) { (error) in
                seal.resolve((), error)
            }
        }
    }
}
