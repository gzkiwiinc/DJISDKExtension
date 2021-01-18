//
//  DJICamera+Promise.swift
//  DJISDKExtension
//
//  Created by Hanson on 2018/8/29.
//

import DJISDK
import PromiseKit

extension DJICamera {
    
    /// Sets the camera's work mode to taking pictures, video, playback or download.
    ///
    /// - Parameters:
    ///   - mode: Camera work mode.
    ///   - force: when camera is recording video, if force is ture, it will stop recording video and set the camera mode
    /// - Returns: Remote execution result error block.
    public func setMode(_ mode: DJICameraMode, force: Bool = false) -> Promise<Void> {
        let isRecording = DJISDKManager.keyManager()?.getValueFor(DJICameraKey(param: DJICameraParamIsRecording)!)?.boolValue ?? false
        if force && isRecording {
            return stopRecordVideo().then {
                return Promise {
                    self.setMode(mode, withCompletion: $0.resolve)
                }
            }
        } else {
            return Promise {
                setMode(mode, withCompletion: $0.resolve)
            }
        }
    }
    
    /// Gets the camera's current work mode. Also supported by thermal imaging camera.
    ///
    /// - Returns: current DJICameraMode
    public func getMode() -> Promise<DJICameraMode> {
        return Promise {
            getModeWithCompletion($0.resolve)
        }
    }
    
    /// Sets the photo shooting mode for the camera.
    ///
    /// - Parameter mode: `DJICameraShootPhotoMode` enum value
    /// - Returns: execution result.
    public func setShootPhotoMode(_ mode: DJICameraShootPhotoMode) -> Promise<Void> {
        return Promise {
            setShootPhotoMode(mode, withCompletion: $0.resolve)
        }
    }
    
    /// get the current photo shooting mode of the camera.
    ///
    /// - Returns: current photo shooting mode
    public func getShootPhotoMode() -> Promise<DJICameraShootPhotoMode> {
        return Promise {
            getShootPhotoMode(completion: $0.resolve)
        }
    }
    
    /// Sets the interval shoot parameters.
    /// - Parameter settings: DJICameraPhotoTimeIntervalSettings
    public func setPhotoTimeIntervalSettings(_ settings: DJICameraPhotoTimeIntervalSettings) -> Promise<Void> {
        return Promise {
            setPhotoTimeIntervalSettings(settings, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the camera's photo file format
    public func setPhotoFileFormat(_ format: DJICameraPhotoFileFormat) -> Promise<Void> {
        return Promise {
            setPhotoFileFormat(format, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the lens focus mode. See `DJICameraFocusMode`.
    public func setFoucusMode(_ mode: DJICameraFocusMode) -> Promise<Void> {
        return Promise {
            setFocusMode(mode, withCompletion: $0.resolve)
        }
    }
    
    public func setFoucusRingValue(_ value: UInt) -> Promise<Void> {
        return Promise {
            setFocusRingValue(value, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the camera's aspect ratio for photos. See `DJICameraPhotoAspectRatio` to view all possible ratios
    public func setPhotoAspectRatio(_ ratio: DJICameraPhotoAspectRatio) -> Promise<Void> {
        return Promise {
            setPhotoAspectRatio(ratio, withCompletion: $0.resolve)
        }
    }

    ///  Sets the camera's exposure metering. See `DJICameraMeteringMode` to view all possible exposure metering settings for the camera.
    public func setMeteringMode(_ mode: DJICameraMeteringMode) -> Promise<Void> {
        return Promise {
            setMeteringMode(mode, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the spot metering area index. The camera image is divided into 96 spots
    /// defined by 12 columns and 8 rows. The row index range is [0,7], where the values
    /// increase top to bottom across the image. The column index range is [0, 11],
    /// where the values increase left to right.
    ///
    /// - Parameters:
    ///   - rowIndex: row index range is [0,7]
    ///   - columnIndex: column index range is [0, 11]
    public func setSpotMeteringTarget(rowIndex: UInt8, columnIndex: UInt8) -> Promise<Void> {
        return Promise {
            setSpotMeteringTargetRowIndex(rowIndex, columnIndex: columnIndex, withCompletion: $0.resolve)
        }
    }
    
    ///  Locks or unlocks the camera's AE (auto exposure).
    ///   Post condition:
    ///   If the AE lock is enabled, the spot metering area cannot be set.
    public func setAELock(_ isLocked: Bool) -> Promise<Void> {
        return Promise {
            setAELock(isLocked, withCompletion: $0.resolve)
        }
    }

    /// Sets the camera's exposure compensation.
    public func setExposureCompensation(_ value: DJICameraExposureCompensation) -> Promise<Void> {
        return Promise {
            setExposureCompensation(value, withCompletion: $0.resolve)
        }
    }
    
    public func setExposureMode(_ mode: DJICameraExposureMode) -> Promise<Void> {
        return Promise {
            setExposureMode(mode, withCompletion: $0.resolve)
        }
    }
    
    public func getISO() -> Promise<DJICameraISO> {
        return Promise {
            getISOWithCompletion($0.resolve)
        }
    }
    
    
    public func setISO(_ iso: DJICameraISO) -> Promise<Void> {
        return Promise {
            setISO(iso, withCompletion: $0.resolve)
        }
    }
    
    public func setISO(value: UInt) -> Promise<Void> {
        guard let iso = DJICameraISO(isoValue: value) else {
            return Promise(error: DJISDKExtensionError.isoValueNotMatchStop)
        }
        return Promise { seal in
            setISO(iso, withCompletion: { (error) in
                if let nsError = error as NSError?,
                    nsError.code == -1005 {
                    seal.fulfill(()) // in some case, even setting is succees, will throw error
                } else if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            })
        }
    }
    
    public func getAperture() -> Promise<DJICameraAperture> {
        return Promise {
            getApertureWithCompletion($0.resolve)
        }
    }
    
    public func setAperture(_ aperture: DJICameraAperture) -> Promise<Void> {
        return Promise {
            setAperture(aperture, withCompletion: $0.resolve)
        }
    }
    
    public func getShutterSpeed() -> Promise<DJICameraShutterSpeed> {
        return Promise {
            getShutterSpeed(completion: $0.resolve)
        }
    }
    
    public func setShutterSpeed(_ shutterSpeed: DJICameraShutterSpeed) -> Promise<Void> {
        return Promise {
            setShutterSpeed(shutterSpeed, withCompletion: $0.resolve)
        }
    }
    
    public func setWhiteBalance(_ whiteBalance: DJICameraWhiteBalance) -> Promise<Void> {
        return Promise {
            setWhiteBalance(whiteBalance, withCompletion: $0.resolve)
        }
    }
    
    public func setColor(_ color: DJICameraColor) -> Promise<Void> {
        return Promise {
            setColor(color, withCompletion: $0.resolve)
        }
    }
    
    public func setVideoFileFormat(_ fileFormat: DJICameraVideoFileFormat) -> Promise<Void> {
        return Promise {
            setVideoFileFormat(fileFormat, withCompletion: $0.resolve)
        }
    }
    
    public func setVideoStandard(_ standard: DJICameraVideoStandard) -> Promise<Void> {
        return Promise {
            setVideoStandard(standard, withCompletion: $0.resolve)
        }
    }
    
    public func setVideoResolutionAndFrameRate(_ resolutionAndFrameRate: DJICameraVideoResolutionAndFrameRate) -> Promise<Void> {
        return Promise {
            setVideoResolutionAndFrameRate(resolutionAndFrameRate, withCompletion: $0.resolve)
        }
    }
    
    public func setVideoDewarpingEnabled(_ enable: Bool) -> Promise<Void> {
        return Promise {
            setVideoDewarpingEnabled(enable, withCompletion: $0.resolve)
        }
    }
    
    /// Gets the storage location.
    ///
    /// - Returns: the storage location.
    public func getStorageLocation() -> Promise<DJICameraStorageLocation> {
        return Promise {
            getStorageLocation(completion: $0.resolve)
        }
    }
    
    public func startShootPhoto() -> Promise<Void> {
        return Promise {
            startShootPhoto(completion: $0.resolve)
        }
    }
    
    public func stopShootPhoto() -> Promise<Void> {
        return Promise {
            stopShootPhoto(completion: $0.resolve)
        }
    }
    
    public func startRecordVideo() -> Promise<Void> {
        return Promise {
            startRecordVideo(completion: $0.resolve)
        }
    }
    
    public func stopRecordVideo() -> Promise<Void> {
        return Promise {
            stopRecordVideo(completion: $0.resolve)
        }
    }
    
    public func setAutoLockGimbalEnabled(_ enabled: Bool) -> Promise<Void> {
        return Promise {
            setAutoLockGimbalEnabled(enabled, withCompletion: $0.resolve)
        }
    }
    
    // MARK: - Flat Camera Mode
    
    /// Sets the camera's flat mode to take photo, record video, or enter intelligent camera modes. Please note that you cannot change the mode when a certain task is executing. This is available only when isFlatCameraModeSupported returns YES.
    public func setFlatMode(_ mode: DJIFlatCameraMode) -> Promise<Void> {
        return Promise {
            setFlatMode(mode, withCompletion: $0.resolve)
        }
    }
    
    public func getFlatMode() -> Promise<DJIFlatCameraMode> {
        return Promise {
            getFlatMode(completion: $0.resolve)
        }
    }
    
    /// Enter playback mode, in which users can preview photos or videos, begin the video playback, and download media to the mobile device. This is available only when isFlatCameraModeSupported returns YES. Please note that only after exiting playback mode, last flat camera mode will be recovered.
    public func enterPlaybackMode() -> Promise<Void> {
        return Promise {
            enterPlayback(completion: $0.resolve)
        }
    }
    
    public func exitPlaybackMode() -> Promise<Void> {
        return Promise {
            exitPlayback(completion: $0.resolve)
        }
    }
    
    // MARK: - Custom
    
    /// get current expoureSetting, using it to lock exposure
    public func setAELockContinuous() -> Promise<Void> {
        return firstly { 
            self.setExposureCompensation(.N00)
        }.then {
            after(seconds: 0.1)
        }.then {
            self.setExposureMode(.manual)
        }.then { () -> Promise<Void> in
            guard let exposureSettings = self.exposureSettings else {
                return Promise(error: PMKError.cancelled)
            }
            return when(fulfilled: self.setISO(value: exposureSettings.ISO),
                            self.isAdjustableApertureSupported() ? self.setAperture(exposureSettings.aperture) : Promise.value(()),
                            self.setShutterSpeed(exposureSettings.shutterSpeed))
        }.asVoid()
    }

}

