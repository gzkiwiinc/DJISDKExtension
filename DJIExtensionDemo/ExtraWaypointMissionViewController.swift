//
//  ExtraWaypointMissionViewController.swift
//  DJIExtensionDemo
//
//  Created by 卓同学 on 2019/1/8.
//  Copyright © 2019 kiwi. All rights reserved.
//

import UIKit
import DJISDKExtension
import DJISDK
import SVProgressHUD
import PromiseKit

class ExtraWaypointMissionViewController: UIViewController {
    
    @IBOutlet weak var coordinateLatTextField: UITextField!
    @IBOutlet weak var coordinateLongTextField: UITextField!
    @IBOutlet weak var waypointsCountTextField: UITextField!
    
    @IBOutlet weak var executeStateLabel: UILabel!
    @IBOutlet weak var waypointIndex: UILabel!
    
    var extraWaypointMission: DJIExtraWaypointMission?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinateLatTextField.text = "30.294873"
        coordinateLongTextField.text = "120.023017"
    }
    
    @IBAction func start(_ sender: Any) {
        guard let mission = createMission() else { return }
        extraWaypointMission = mission
        mission.delegate = self
        mission.startMission().catch { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    private func createMission() -> DJIExtraWaypointMission? {
        let basicLat = Double(coordinateLatTextField.text!)!
        let basicLong = Double(coordinateLongTextField.text!)!
        
        let count = Int(waypointsCountTextField.text!)!
        let offset: Double = 0.00001
        let waypoints: [DJIWaypoint] = (0 ..< count).map {
            let offset = offset * Double($0)
            let long = basicLong + offset
            var lat = basicLat
            if $0 % 2 == 0 {
                lat = basicLat + 0.00001
            } else {
                lat = basicLat - 0.00001
            }
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            return DJIWaypoint(coordinate: coordinate)
        }
        let waypointMission = DJIMutableWaypointMission()
        waypointMission.finishedAction = .noAction
        do {
            let extraMission = try DJIExtraWaypointMission(mission: waypointMission, waypoints: waypoints)
            return extraMission
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            return nil
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        guard let mission = extraWaypointMission else { return }
        mission.pauseMission().catch { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    @IBAction func resume(_ sender: Any) {
        guard let mission = extraWaypointMission else { return }
        mission.resumeMission().catch { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        guard let mission = extraWaypointMission else { return }
        mission.stopMission().catch { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}

extension ExtraWaypointMissionViewController: DJIExtraWaypointMissionDelegate {
    
    func waypointMissionPrepareStart(_ mission: DJIWaypointMission) {
        DispatchQueue.main.async {
            self.executeStateLabel.text = "PrepareStart"
        }
    }
    
    func waypointMissionStartExecuting(_ mission: DJIWaypointMission, missionIndex: Int) {
        DispatchQueue.main.async {
            self.executeStateLabel.text = "StartExecuting"
        }
    }
    
    func waypointMissionDidStop(_ mission: DJIWaypointMission, error: Error?) {
        DispatchQueue.main.async {
            self.executeStateLabel.text = "DidStop"
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    func waypointMissionDidPaused(_ mission: DJIWaypointMission) {
        DispatchQueue.main.async {
            self.executeStateLabel.text = "DidPaused"
        }
    }
    
    func waypointMissionDidFinished() {
        DispatchQueue.main.async {
            self.executeStateLabel.text = "DidFinished"
        }
    }
    
    func waypointMissionExecuting(_ mission: DJIWaypointMission, executionEvent: DJIWaypointMissionExecutionEvent) {
        DispatchQueue.main.async {
            self.waypointIndex.text = String(self.extraWaypointMission!.targetWaypointIndex)
        }
    }
    
}
