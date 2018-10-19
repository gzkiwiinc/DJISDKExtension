//
//  DJITimelineBasicEvent.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/19.
//  Copyright © 2018 kiwi. All rights reserved.
//

import Foundation
import PromiseKit

public struct DJITimelineBasicEvent: DJITimelineEvent {
    
    public let promise: Promise<Void>
    
    init(promise: Promise<Void>) {
        self.promise = promise
    }
    
    public func start() -> Promise<Void> {
        return promise
    }
    
}
