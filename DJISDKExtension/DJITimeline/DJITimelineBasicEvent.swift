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
    
    public let promiseWrapper: () -> Promise<Void>
    
    public init(wrapper: @escaping () -> Promise<Void>) {
        self.promiseWrapper = wrapper
    }
    
    public func start() -> Promise<Void> {
        return promiseWrapper()
    }
    
}
