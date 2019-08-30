//
//  DJITimelineAELockEvent.swift
//  DJISDKExtension
//
//  Created by Hanson on 2019/8/30.
//  Copyright © 2019 kiwi. All rights reserved.
//

import Foundation
import PromiseKit
import DJISDK

public struct DJITimelineAELockEvent: DJITimelineEvent {
    
    public let isLocked: Bool
    
    public init(isLocked: Bool) {
        self.isLocked = isLocked
    }
    
    public func start() -> Promise<Void> {
        guard let camera = DJISDKManager.aircraft?.camera else {
            return Promise(error: DJITimelineMissionError.aircraftStateError("can't get camera state"))
        }
        return camera.setAELock(isLocked)
    }
    
}
