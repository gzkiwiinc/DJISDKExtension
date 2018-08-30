//
//  DJIDeviceHelper.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/8/30.
//  Copyright © 2018年 kiwi. All rights reserved.
//

import Foundation
import DJISDK

public class DJIDeviceHelper {
    
    /// dji product's camera
    public static var camera: DJICamera? {
        guard let product = DJISDKManager.product() else { return nil }
        if let aircraft = product as? DJIAircraft {
            return aircraft.camera
        } else if let handheld = product as? DJIHandheld {
            return handheld.camera
        }
        return nil
    }

}
