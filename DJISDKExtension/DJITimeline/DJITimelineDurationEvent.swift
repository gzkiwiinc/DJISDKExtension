//
//  DJITimelineSecondsEvent.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/19.
//  Copyright © 2018 kiwi. All rights reserved.
//

import Foundation
import PromiseKit

public struct DJITimelineDurationEvent: DJITimelineEvent {
    
    public let seconds:TimeInterval
    
    public init(seconds: TimeInterval) {
        self.seconds = seconds
    }
    
    public func start() -> Promise<Void> {
        return Promise(after(seconds: seconds))
    }
    
}
