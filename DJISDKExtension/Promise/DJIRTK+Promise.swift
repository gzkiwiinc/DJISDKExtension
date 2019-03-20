//
//  DJIRTK+Promise.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/3/7.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIRTK {
    public func setRTKEnabled(_ enabled: Bool) -> Promise<Void> {
        return Promise {
            setRTKEnabled(enabled, withCompletion: $0.resolve)
        }
    }
    
    public func getRTKEnabled() -> Promise<Bool> {
        return Promise {
            getEnabledWithCompletion($0.resolve)
        }
    }
    
    public func setReferenceStationSource(_ source: DJIRTKReferenceStationSource) -> Promise<Void> {
        return Promise {
            setReferenceStationSource(source, withCompletion: $0.resolve)
        }
    }
}
