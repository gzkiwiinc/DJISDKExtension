//
//  DJIFlightController+Promise.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/9/28.
//  Copyright © 2018 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIFlightController {
    
    /// Enables/disables virtual stick control mode.
    public func setVirtualStickModeEnabled(_ enabled: Bool) -> Promise<Void> {
        return Promise {
            setVirtualStickModeEnabled(enabled, withCompletion: $0.resolve)
        }
    }
    
    /// Sends flight control data using virtual stick commands
    public func sendVirtualStickControlData(_ data: DJIVirtualStickFlightControlData) -> Promise<Void> {
        return Promise {
            send(data, withCompletion: $0.resolve)
        }
    }
    
    public func startGoHome() -> Promise<Void> {
        return Promise {
            startGoHome(completion: $0.resolve)
        }
    }
    
    /// Gets the low battery warning threshold as a percentage.
    public func getLowBatteryWarningThreshold() -> Promise<UInt8> {
        return Promise {
            getLowBatteryWarningThreshold(completion: $0.resolve)
        }
    }
    
    /// Gets the serious low battery warning threshold in percentage.
    public func getSeriousLowBatteryWarningThreshold() -> Promise<UInt8> {
        return Promise {
            getSeriousLowBatteryWarningThreshold(completion: $0.resolve)
        }
    }
}
