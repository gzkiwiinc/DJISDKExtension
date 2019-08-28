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
        let isoRange = capabilities.isoRange()
        if isoRange.count == 1
         , isoRange[0] == isoAutoValue {
            return false
        }
        return isoRange.contains(isoAutoValue)
    }
    
    var isSupportShutterPriority: Bool {
        let shutterPriorityModeValue = NSNumber(value: DJICameraExposureMode.shutterPriority.rawValue)
        return capabilities.exposureModeRange().contains(shutterPriorityModeValue)
    }
    
    var minimumPhotoInterval: UInt16? {
       return capabilities.photoIntervalRange().first?.uint16Value
    }
}
