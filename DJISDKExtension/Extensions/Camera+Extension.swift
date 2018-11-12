//
//  Camera+Extension.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/11/10.
//  Copyright © 2018 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJICamera {
    private struct AssociatedKeys {
        static var exposureSettingKey = "exposureSettingKey"
    }
    
    public var exposureSettings: DJICameraExposureSettings? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.exposureSettingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.exposureSettingKey) as? DJICameraExposureSettings
        }
    }
}

extension DJICameraISO {
    public init?(isoValue: UInt) {
        switch isoValue {
        case 100:
            self = .ISO100
        case 200:
            self = .ISO200
        case 400:
            self = .ISO400
        case 800:
            self = .ISO800
        case 1600:
            self = .ISO1600
        case 3200:
            self = .ISO3200
        case 6400:
            self = .ISO6400
        case 12800:
            self = .ISO12800
        case 25600:
            self = .ISO25600
        default:
            return nil
        }
    }
}
