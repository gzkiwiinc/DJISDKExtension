//
//  DJICameraKey+Promise.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/12/10.
//  Copyright © 2018 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJICamera {

    /// get exposureSettings through DJICameraParamExposureSettings
    public var exposureSettings: DJICameraExposureSettings? {
        guard let key = DJICameraKey(param: DJICameraParamExposureSettings)
            , let exposureValue = DJISDKManager.keyManager()?.getValueFor(key)?.value as? NSValue else {
                return nil
        }
        var exposureSettings = DJICameraExposureSettings(aperture: DJICameraAperture.unknown,
                                                         shutterSpeed: DJICameraShutterSpeed.speedUnknown,
                                                         ISO: DJICameraISO.isoUnknown.rawValue,
                                                         exposureCompensation: DJICameraExposureCompensation.unknown,
                                                         EI: 0,
                                                         exposureState: DJICameraExposureState.unknown)
        exposureValue.getValue(&exposureSettings)
        if exposureSettings.aperture == DJICameraAperture.unknown {
            return nil
        }
        return exposureSettings
    }
}
