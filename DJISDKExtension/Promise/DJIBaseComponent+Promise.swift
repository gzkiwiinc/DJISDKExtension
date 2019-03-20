//
//  DJIBaseComponent+Promise.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/3/20.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIBaseComponent {
    
    public func getSerialNumber() -> Promise<String> {
        return Promise {
            getSerialNumber(completion: $0.resolve)
        }
    }
    
    public func getFirmwareVersion() -> Promise<String> {
        return Promise {
            getFirmwareVersion(completion: $0.resolve)
        }
    }
}
