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
    
    public func setGoHomeHeightInMeters(height: UInt) -> Promise<Void> {
        return Promise {
            setGoHomeHeightInMeters(height, withCompletion: $0.resolve)
        }
    }
    
    public func cancelGoHome() -> Promise<Void> {
        return Promise {
            cancelGoHome(completion: $0.resolve)
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
    
    ///  Sets the low battery warning threshold as a percentage. The percentage must be
    ///  in the range of [15, 50].
    public func setLowBatteryWarningThreshold(_ percent: UInt8) -> Promise<Void> {
        return Promise {
            setLowBatteryWarningThreshold(percent, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the serious low battery warning threshold as a percentage. The minimum
    ///  value is 10. The maximum value is value from
    ///  `getLowBatteryWarningThresholdWithCompletion` minus 5.
    public func setSeriousLowBatteryWarningThreshold(_ percent: UInt8) -> Promise<Void> {
        return Promise {
            setSeriousLowBatteryWarningThreshold(percent, withCompletion: $0.resolve)
        }
    }
}
