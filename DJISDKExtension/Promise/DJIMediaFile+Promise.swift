//
//  DJIMediaFile+Promise.swift
//  DJISDKExtension
//
//  Created by Hanson on 2018/8/30.
//

import DJISDK
import PromiseKit

extension DJIMediaFile {
    
    /// Fetches this media's thumbnail with a resolution (99 x 99) from the SD card.
    ///
    /// - Returns: Promise result
    public func fetchThumbnail() -> Promise<Void> {
        return Promise {
            fetchThumbnail(completion: $0.resolve)
        }
    }
    
    /// Fetch media's preview image. The preview image is a lower resolution (960 x 540) version of a photo.
    ///
    /// - Returns: Promise result
    public func fetchPreview() -> Promise<Void> {
        return Promise {
            fetchPreview(completion: $0.resolve)
        }
    }
    
    /// Fetch media file's full resolution data from the SD card.
    ///
    /// - Returns: file data
    public func fetchFileData(dispatchQueue: DispatchQueue) -> Promise<Data> {
        return Promise { seal in
            var fileData = Data()
            fetchData(withOffset: 0, update: dispatchQueue) { (data, isComplete, error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    if let data = data {
                        fileData.append(data)
                    }
                    if isComplete {
                        seal.fulfill(fileData)
                    }
                }
            }
        }
    }
    
    /// Fetch media file's full resolution data with update progress
    ///
    /// - Parameters:
    ///   - dispatchQueue: dispatchQueue to call
    ///   - updateProgress: block to show the progress
    /// - Returns: file data
    public func fetchFileData(dispatchQueue: DispatchQueue,
                              updateProgress: @escaping (_ progress: CGFloat) -> Void) -> Promise<Data>
    {
        return Promise { seal in
            var fileData = Data()
            var previousOffset: UInt = 0
            fetchData(withOffset: 0, update: dispatchQueue) { (data, isComplete, error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    if let data = data {
                        fileData.append(data)
                        previousOffset = previousOffset + UInt(data.count)
                    }
                    if isComplete {
                        seal.fulfill(fileData)
                    } else {
                        let progress = (CGFloat(previousOffset) * 100.0) / CGFloat(self.fileSizeInBytes)
                        updateProgress(progress)
                    }
                }
            }
        }
    }
    
    /// Stop fetching the current media file data
    public func stopFetchFileData() -> Promise<Void> {
        return Promise {
            stopFetchingFileData(completion: $0.resolve)
        }
    }
}
