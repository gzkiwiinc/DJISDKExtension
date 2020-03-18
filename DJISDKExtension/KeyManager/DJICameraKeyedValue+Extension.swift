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
    
    /// Returns the latest known value the type expected if available for the camera key.
    public func getValue<T>(cameraKey: String) -> T? {
        guard let key = DJICameraKey(param: cameraKey) else { return nil }
        return DJISDKManager.keyManager()?.getValueForKey(key)
    }
    
    /// Returns the latest known enum value the type expected if available for the camera key.
    public func getEnumValue<T>(cameraKey: String) -> T? where T: RawRepresentable, T.RawValue == UInt {
        guard let value: UInt = getValue(cameraKey: cameraKey) else { return nil }
        return T(rawValue: value)
    }
    
    public var mode: DJICameraMode {
        return getEnumValue(cameraKey: DJICameraParamMode) ?? .unknown
    }
    
    public var shootPhotoMode: DJICameraShootPhotoMode {
        return getEnumValue(cameraKey: DJICameraParamShootPhotoMode) ?? .unknown
    }
    
    public var photoFileFormat: DJICameraPhotoFileFormat {
        return getEnumValue(cameraKey: DJICameraParamPhotoFileFormat) ?? .unknown
    }
    
    public var photoAspectRatio: DJICameraPhotoAspectRatio {
        return getEnumValue(cameraKey: DJICameraParamPhotoAspectRatio) ?? .unknown
    }
    
    public var videoFileFormat: DJICameraVideoFileFormat {
        return getEnumValue(cameraKey: DJICameraParamVideoFileFormat) ?? .unknown
    }
    
    public var videoResolutionAndFrameRate: DJICameraVideoResolutionAndFrameRate? {
        return getValue(cameraKey: DJICameraParamVideoResolutionAndFrameRate)
    }
}
