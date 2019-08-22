//
//  DJITimelineMissionError.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/10/18.
//  Copyright © 2018 kiwi. All rights reserved.
//

import Foundation

public enum DJITimelineMissionError: LocalizedError {
    case aircraftStateError(String)
    
    public var errorDescription: String? {
        switch self {
        case .aircraftStateError(let description):
            return "AircraftState Error: \(description)"
        }
    }
}
