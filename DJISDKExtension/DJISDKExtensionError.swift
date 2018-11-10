//
//  DJISDKExtensionError.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/11/10.
//  Copyright © 2018 kiwi. All rights reserved.
//

import DJISDK

public enum DJISDKExtensionError: LocalizedError {
    case isoValueNotMatchStop
    
    public var errorDescription: String {
        switch self {
        case .isoValueNotMatchStop:
            return "ISO value don't match DJICameraISO stop"
        }
    }
}
