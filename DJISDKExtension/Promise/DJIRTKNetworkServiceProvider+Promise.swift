//
//  DJIRTKNetworkServiceProvider+Promise.swift
//  DJISDKExtension
//
//  Created by 卓同学 on 2019/3/13.
//  Copyright © 2019 kiwi. All rights reserved.
//

import DJISDK
import PromiseKit

extension DJIRTKNetworkServiceProvider {
    
    public func startNetworkService() -> Promise<Void> {
        return Promise {
            startNetworkService(completion: $0.resolve)
        }
    }
    
    public func stopNetworkService() -> Promise<Void> {
        return Promise {
            stopNetworkService(completion: $0.resolve)
        }
    }

    public func setNetworkServiceCoordinateSystem(_ coordinateSystem: DJIRTKNetworkServiceCoordinateSystem) -> Promise<Void> {
        return Promise {
            setNetworkServiceCoordinateSystem(coordinateSystem, completion: $0.resolve)
        }
    }
    
    public func getNetworkServiceOrderPlans() -> Promise<DJIRTKNetworkServicePlansState?> {
        return Promise { seal in
            getNetworkServiceOrderPlans(completion: { (plans, error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(plans)
                }
            })
        }
    }
}

fileprivate class OCNilContainer<T> {
    var value: T?
    
    init(_ value: T?) {
        self.value = value
    }
}
