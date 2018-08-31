//
//  DJIMediaManager+Promise.swift
//  DJISDKExtension
//
//  Created by Hanson on 2018/8/29.
//

import DJISDK
import PromiseKit

extension DJIMediaManager {

    
    /// Error define by DJISDKExtension for DJIMediaManager
    ///
    /// - deleteFail: fail to delete and the error contains the array of fialed DJIMediaFile.
    public enum DJIMediaManagerError: Error {
        case deleteFail(failedFiles: [DJIMediaFile], djiError: Error)
    }
    
    /// Refreshes the file list of the storage and Returns a copy of the current file list on the internal storage.
    ///
    /// - Parameter storageLocation: The storage location of the file list to refresh.
    /// - Returns: an array of `DJIMediaFile` objects.
    public func fetchMediaFileListSnapshotOf(storageLocation: DJICameraStorageLocation) -> Promise<[DJIMediaFile]> {
        return Promise { seal in
            refreshFileList(of: storageLocation, withCompletion: { error in
                switch storageLocation {
                case .internalStorage:
                    seal.resolve(self.internalStoragefileListSnapshot() ?? [], error)
                case .sdCard:
                    seal.resolve(self.sdCardFileListSnapshot() ?? [], error)
                case .unknown:
                    seal.resolve([], error)
                }
            })
        }
    }
    
    /// fetch contents of a media file using DJIFetchMediaTask.
    ///
    /// - Parameters:
    ///   - mediaFile: the DJIMediaFile to fetch contents.
    ///   - mediaContentType: The content to download in a fetch media file task.
    /// - Returns: The media file that the content belongs to.
    public func fetchMediaContent(mediaFile: DJIMediaFile, mediaContentType: DJIFetchMediaTaskContent) -> Promise<DJIMediaFile> {
        return Promise { seal in
            let mediaTaskScheduler = self.taskScheduler
            mediaTaskScheduler.suspendAfterSingleFetchTaskFailure = false
            mediaTaskScheduler.resume(completion: nil)
            let fetchTask = DJIFetchMediaTask(file: mediaFile, content: mediaContentType) {
                (mediaFile, _, error) in
                seal.resolve(mediaFile, error)
            }
            mediaTaskScheduler.moveTask(toEnd: fetchTask)
        }
    }
    
    /// Delete media files from storages
    ///
    /// - Parameter mediaFiles: Media files to delete.
    /// - Returns: Promise<Void>
    public func delete(mediaFiles: [DJIMediaFile]) -> Promise<Void> {
        return Promise { seal in
            delete(mediaFiles) { (failedFiles, error) in
                if let error = error {
                    seal.reject(DJIMediaManagerError.deleteFail(failedFiles: failedFiles, djiError: error))
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
}

