//
//  DJIFileManageError.swift
//  DJISDKExtension
//
//  Created by Hanson on 2018/8/31.
//

import DJISDK

enum DJIFileManageError: Error, LocalizedError {
    case notSupportType
    case deleteFileFail([DJIMediaFile])
    
    var errorDescription: String? {
        switch self {
        case .notSupportType:
            return "the type of media file is not supported for the excution."
        case .deleteFileFail:
            return "fail to delete the file."
        }
    }
}
