//
//  DJITimelineShootPhotoEvent.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/18.
//  Copyright © 2018 kiwi. All rights reserved.
//

import Foundation
import DJISDK
import PromiseKit

public struct DJITimelineShootPhotoEvent: DJITimelineEvent {
    
    public init() { }
    
    public func start() -> Promise<Void> {
        guard let camera = DJISDKManager.aircraft?.camera else {
            return Promise(error: DJITimelineMissionError.aircraftStateError("can't get camera state"))
        }
        return camera.startShootPhoto()
    }
    
}
