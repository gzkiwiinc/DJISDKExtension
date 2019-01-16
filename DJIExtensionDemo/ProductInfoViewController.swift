//
//  ProductInfoViewController.swift
//  DJILibDemo
//
//  Created by 卓同学 on 2018/12/3.
//  Copyright © 2018 kiwi. All rights reserved.
//

import UIKit
import DJISDK
import SVProgressHUD

class ProductInfoViewController: UIViewController, DJIAppActivationManagerDelegate {
    
    @IBOutlet weak var lbActivation: UILabel!
    @IBOutlet weak var lbBinding: UILabel!
    @IBOutlet weak var lbFirmware: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DJISDKManager.appActivationManager().delegate = self
        checkActivationStatus()
        DJISDKManager.product()?.getFirmwarePackageVersion(completion: { (version, error) in
            if let version = version {
                self.lbFirmware.text = version
            }
        })
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        DJISDKManager.userAccountManager().logIntoDJIUserAccount(withAuthorizationRequired: false) { (state, error) in
            if let error = error {
                SVProgressHUD.showInfo(withStatus: error.localizedDescription)
            } else {
                self.checkActivationStatus()
            }
        }
    }
    
    func manager(_ manager: DJIAppActivationManager!, didUpdate appActivationState: DJIAppActivationState) {
        checkActivationStatus()
    }
    
    func manager(_ manager: DJIAppActivationManager!, didUpdate aircraftBindingState: DJIAppActivationAircraftBindingState) {
        checkActivationStatus()
    }
    
    private func checkActivationStatus() {
        let activationState = DJISDKManager.appActivationManager().appActivationState
        if activationState == .activated {
            lbActivation.text = "activated"
        } else {
            lbActivation.text = "ActivationState：\(activationState.rawValue)"
        }
        let aircraftBindingState = DJISDKManager.appActivationManager().aircraftBindingState
        let isBinding = aircraftBindingState == .notRequired || aircraftBindingState == .bound
        if isBinding {
            lbBinding.text = "bound"
        } else {
            lbBinding.text = "BindingState：\(aircraftBindingState.rawValue)"
        }
    }
}
