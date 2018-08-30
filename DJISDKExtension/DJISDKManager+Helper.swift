//
//  DJIDeviceHelper.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/8/30.
//  Copyright © 2018年 kiwi. All rights reserved.
//

import Foundation
import DJISDK

extension DJISDKManager {
    
    /// return DJIAircraft if current product is DJIAircraft
    public static var aircraft: DJIAircraft? {
        return product() as? DJIAircraft
    }
    
    /// return DJIHandheld if current product is DJIHandheld
    public static var handheld: DJIHandheld? {
        return product() as? DJIHandheld
    }
    
}
