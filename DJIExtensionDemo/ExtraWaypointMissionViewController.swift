//
//  ExtraWaypointMissionViewController.swift
//  DJIExtensionDemo
//
//  Created by 卓同学 on 2019/1/8.
//  Copyright © 2019 kiwi. All rights reserved.
//

import UIKit
import DJISDKExtension

class ExtraWaypointMissionViewController: UIViewController {
    
    @IBOutlet weak var coordinateLatTextField: UITextField!
    @IBOutlet weak var coordinateLongTextField: UITextField!
    @IBOutlet weak var waypointsCountTextField: UITextField!
    
    @IBOutlet weak var executeStateLabel: UILabel!
    @IBOutlet weak var waypointIndex: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
