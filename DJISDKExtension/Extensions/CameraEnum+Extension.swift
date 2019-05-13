//
//  Camera+Extension.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2018/11/10.
//  Copyright © 2018 kiwi. All rights reserved.
//

import DJISDK

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

public extension DJICameraShutterSpeed {
    
    var seconds: Float {
        switch self {
        case .speed1_8000:
            return 1/8000
        case .speed1_6400:
            return 1/6400
        case .speed1_6000:
            return 1/6000
        case .speed1_5000:
            return 1/5000
        case .speed1_4000:
            return 1/4000
        case .speed1_3200:
            return 1/3200
        case .speed1_3000:
            return 1/3000
        case .speed1_2500:
            return 1/2500
        case .speed1_2000:
            return 1/2000
        case .speed1_1500:
            return 1/1600
        case .speed1_1600:
            return 1/1500
        case .speed1_1250:
            return 1/1250
        case .speed1_1000:
            return 1/1000
        case .speed1_800:
            return 1/800
        case .speed1_750:
            return 1/750
        case .speed1_725:
            return 1/725
        case .speed1_640:
            return 1/640
        case .speed1_500:
            return 1/500
        case .speed1_400:
            return 1/400
        case .speed1_350:
            return 1/350
        case .speed1_320:
            return 1/320
        case .speed1_250:
            return 1/250
        case .speed1_240:
            return 1/240
        case .speed1_200:
            return 1/200
        case .speed1_180:
            return 1/180
        case .speed1_160:
            return 1/160
        case .speed1_125:
            return 1/125
        case .speed1_120:
            return 1/120
        case .speed1_100:
            return 1/100
        case .speed1_90:
            return 1/90
        case .speed1_80:
            return 1/80
        case .speed1_60:
            return 1/60
        case .speed1_50:
            return 1/50
        case .speed1_45:
            return 1/45
        case .speed1_40:
            return 1/40
        case .speed1_30:
            return 1/30
        case .speed1_25:
            return 1/25
        case .speed1_20:
            return 1/20
        case .speed1_15:
            return 1/15
        case .speed1_12Dot5:
            return 1/12.5
        case .speed1_10:
            return 1/10
        case .speed1_8:
            return 1/8
        case .speed1_6Dot25:
            return 1/6.25
        case .speed1_6:
            return 1/6
        case .speed1_5:
            return 1/5
        case .speed1_4:
            return 1/4
        case .speed1_3:
            return 1/3
        case .speed1_2Dot5:
            return 1/2.5
        case .speed0Dot3:
            return 0.3
        case .speed1_2:
            return 1/2
        case .speed1_1Dot67:
            return 1/1.67
        case .speed1_1Dot25:
            return 1/1.25
        case .speed0Dot7:
            return 0.7
        case .speed1:
            return 1.0
        case .speed1Dot3:
            return 1.3
        case .speed1Dot4:
            return 1.4
        case .speed1Dot6:
            return 1.6
        case .speed2:
            return 2.0
        case .speed2Dot5:
            return 2.5
        case .speed3:
            return 3.0
        case .speed3Dot2:
            return 3.2
        case .speed4:
            return 4.0
        case .speed5:
            return 5.0
        case .speed6:
            return 6.0
        case .speed7:
            return 7.0
        case .speed8:
            return 8.0
        case .speed9:
            return 9.0
        case .speed10:
            return 10.0
        case .speed11:
            return 11.0
        case .speed13:
            return 13.0
        case .speed15:
            return 15.0
        case .speed16:
            return 16.0
        case .speed20:
            return 20.0
        case .speed23:
            return 23.0
        case .speed25:
            return 25.0
        case .speed30:
            return 30.0
        case .speedUnknown:
            return 0
        @unknown default:
            return 0
        }
    }
}

public extension DJICamera {
    var isSupportAutoISO: Bool {
        let isoAutoValue = NSNumber(value: DJICameraISO.isoAuto.rawValue)
        guard let _ = capabilities.isoRange().firstIndex(of: isoAutoValue) else { return false }
        return true
    }
}
