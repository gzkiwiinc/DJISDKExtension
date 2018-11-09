//
//  DJISDKExtensionTests.swift
//  DJISDKExtensionTests
//
//  Created by 卓同学 on 2018/11/9.
//  Copyright © 2018 kiwi. All rights reserved.
//

import XCTest
import PromiseKit
@testable import DJISDKExtension

class DJISDKTimelineTests: XCTestCase, DJITimelineMissionDelegate {

    var expection: XCTestExpectation?
    func testTimeline() {
        expection = expectation(description: #function)
        var events = [DJITimelineEvent]()
        events.append(DJITimelineDurationEvent(seconds: 1))
        events.append(CustomeTimelineEvent())
        events.append(DJITimelineDurationEvent(seconds: 1))
        let timeline = DJITimelineMission(events: events)
        timeline.delegate = self
        timeline.prepareStart = {
            return Promise(resolver: { (seal) in
            print("prepareStart")
            seal.fulfill(())
        })}
        timeline.start()
        waitForExpectations(timeout: 6) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func timelineMissionDidStart(_ mission: DJITimelineMission, isResume: Bool, error: Error?) {
        print("timelineMissionDidStart \(Date().timeIntervalSince1970)")
        if let error = error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func timelineMission(_ mission: DJITimelineMission, executedEvent: DJITimelineEvent, error: Error?) {
        print("executedEvent \(executedEvent) \(Date().timeIntervalSince1970)")
    }
    
    func timelineMissionDidPaused(_ mission: DJITimelineMission) {
        
    }
    
    func timelineMissionDidFinished(_ mission: DJITimelineMission) {
        print("timelineMissionDidFinished \(Date().timeIntervalSince1970)")
        expection?.fulfill()
    }
    
    func timelineMissionDidStopped(_ mission: DJITimelineMission, error: Error?) {
        
    }

}

struct CustomeTimelineEvent: DJITimelineEvent {
    
    func start() -> Promise<Void> {
        return Promise(resolver: { (seal) in
            print("执行custome")
            seal.fulfill(())
        })
    }
    
    
}
