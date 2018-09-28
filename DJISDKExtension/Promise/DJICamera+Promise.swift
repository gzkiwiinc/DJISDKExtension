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
    /// - Parameter mode: Camera work mode.
    /// - Returns: Remote execution result error block.
    public func setMode(_ mode: DJICameraMode) -> Promise<Void> {
        return Promise {
            setMode(mode, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the lens focus mode. See `DJICameraFocusMode`.
    public func setFoucusMode(_ mode: DJICameraFocusMode) -> Promise<Void> {
        return Promise {
            setFocusMode(mode, withCompletion: $0.resolve)
        }
    }
    
    /// Sets the camera's aspect ratio for photos. See `DJICameraPhotoAspectRatio` to view all possible ratios
    public func setPhotoAspectRatio(_ ratio: DJICameraPhotoAspectRatio) -> Promise<Void> {
        return Promise {
            setPhotoAspectRatio(ratio, withCompletion: $0.resolve)
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
}
