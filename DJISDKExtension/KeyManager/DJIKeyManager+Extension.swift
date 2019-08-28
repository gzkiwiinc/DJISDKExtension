//
//  DJIKeyManager+Extension.swift
//  DJISDKExtension
//
//  Created by huluobo on 2019/8/12.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK

public extension DJIKeyManager {
    
    /// Returns the latest known value the type expected if available for the key.
    func getValueForKey<T>(_ key: DJIKey) -> T? {
        let keyedValue = getValueFor(key)
        return keyedValue?.value as? T
    }
    
    /// Returns the latest known enum value the type expected if available for the key.
    func getEnumValueForKey<T>(_ key: DJIKey) -> T? where T: RawRepresentable, T.RawValue == UInt {
        guard let value: UInt = getValueForKey(key) else { return nil }
        return T(rawValue: value)
    }
}
