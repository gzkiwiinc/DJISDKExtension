//
//  RootTableViewController.swift
//  DJIExtensionDemo
//
//  Created by 卓同学 on 2019/1/8.
//  Copyright © 2019 kiwi. All rights reserved.
//

import UIKit
import DJISDK
import SVProgressHUD

class RootTableViewController: UITableViewController, DJISDKManagerDelegate {

    @IBOutlet weak var productInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DJISDKManager.registerApp(with: self)
    }

    func appRegisteredWithError(_ error: Error?) {
        if let error = error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        } else {
            DJISDKManager.startConnectionToProduct()
        }
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        if let product = product {
            productInfoLabel.text = product.model
        }
    }
    
    func productDisconnected() {
        productInfoLabel.text = "disconnect"
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        
    }
}
