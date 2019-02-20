//
//  DJIMissionControl+Promise.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/2/20.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIMissionControl {
    
    /// if a mission is started, stop mission.
    public func stopStartedMission() -> Promise<Void> {
        guard let startedOperator = getStartedOperator() else {
            return Promise.value(())
        }
        return getOperator(startedOperator).stopMission()
    }
    
}

