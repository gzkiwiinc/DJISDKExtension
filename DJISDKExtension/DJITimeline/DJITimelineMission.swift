//
//  DJITimeline.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/18.
//  Copyright © 2018 kiwi. All rights reserved.
//

import UIKit
import PromiseKit

public protocol DJITimelineEvent {
    func start() -> Promise<Void>
}

public protocol DJITimelineMissionDelegate: class {
    func timelineMissionDidStart(_ mission: DJITimelineMission, error: Error?)
    func timelineMission(_ mission: DJITimelineMission, executedEvent: DJITimelineEvent, error: Error?)
    func timelineMissionDidFinished(_ mission: DJITimelineMission)
    func timelineMissionDidStopped(_ mission: DJITimelineMission, error: Error?)
}

open class DJITimelineMission {
    
    private(set) public var events: [DJITimelineEvent]
    public weak var delegate: DJITimelineMissionDelegate?
    
    public var executeEventIndex = 0
    private(set) public var isPaused = false

    public var prepareStart: Promise<Void>?

    public init(events: [DJITimelineEvent]) {
        self.events = events
    }
    
    public func start(resume: Bool = true) {
        if resume == false {
            executeEventIndex = 0
        }
        isPaused = false
        firstly {
            prepareStart ?? Promise.value(())
        }.done {
            self.delegate?.timelineMissionDidStart(self, error: nil)
            self.executeEvent()
        }.catch { (error) in
            self.delegate?.timelineMissionDidStart(self, error: error)
        }
    }
    
    public func pause() {
        isPaused = true
    }
    
    public func stop() {
        isPaused = true
        delegate?.timelineMissionDidStopped(self, error: nil)
    }
    
    private func executeEvent() {
        guard isPaused == false else {
            return
        }
        guard executeEventIndex < events.count else {
            delegate?.timelineMissionDidFinished(self)
            executeEventIndex = 0
            return
        }
        let event = events[executeEventIndex]
        firstly {
            event.start()
        }.done {
            self.delegate?.timelineMission(self, executedEvent: event, error: nil)
            self.executeEventIndex += 1
            self.executeEvent()
        }.catch {
            self.delegate?.timelineMission(self, executedEvent: event, error: $0)
        }
    }
}
