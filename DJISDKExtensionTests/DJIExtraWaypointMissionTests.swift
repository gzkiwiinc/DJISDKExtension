//
//  DJIExtraWaypointMissionTests.swift
//  DJISDKExtensionTests
//
//  Created by 卓同学 on 2019/1/7.
//  Copyright © 2019 kiwi. All rights reserved.
//

import XCTest
import DJISDK
@testable import DJISDKExtension

class DJIExtraWaypointMissionTests: XCTestCase {

    func testGroupWaypoints() {
       let basicWaypoint = DJIWaypoint(coordinate: CLLocationCoordinate2D())
       let oneGroupWaypoints = [basicWaypoint, basicWaypoint]
       let oneGroup = DJIExtraWaypointMission.groupWaypoints(oneGroupWaypoints)
       XCTAssert(oneGroup.count == 1)
        
        let twoGroupWaypoints = (0 ..< 100).map { _ in return basicWaypoint }
        let twoGroup = DJIExtraWaypointMission.groupWaypoints(twoGroupWaypoints)
        XCTAssert(twoGroup.count == 2)
        XCTAssert(twoGroup[1].count == 2)
    }

}
