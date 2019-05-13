//
//  Camera+Extension.swift
//  DJISDKExtension
//
//  Created by huluobo on 2019/5/13.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

public extension DJICamera {
    var isSupportAutoISO: Bool {
        let isoAutoValue = NSNumber(value: DJICameraISO.isoAuto.rawValue)
        return capabilities.isoRange().contains(isoAutoValue)
    }
    
    var isSupportShutterPriority: Bool {
        let shutterPriorityModeValue = NSNumber(value: DJICameraExposureMode.shutterPriority.rawValue)
        return capabilities.exposureModeRange().contains(shutterPriorityModeValue)
    }
}
