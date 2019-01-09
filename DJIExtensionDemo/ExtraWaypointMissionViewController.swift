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
        let lat = Double(coordinateLatTextField.text!)!
        let basicLong = Double(coordinateLongTextField.text!)!
        
        let count = Int(waypointsCountTextField.text!)!
        let offset: Double = 0.000001
        let waypoints: [DJIWaypoint] = (0 ..< count).map {
            let offset = offset * Double($0)
            let long = basicLong + offset
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            return DJIWaypoint(coordinate: coordinate)
        }
        let waypointMission = DJIMutableWaypointMission()
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
        SVProgressHUD.showInfo(withStatus: "PrepareStart")
    }
    
    func waypointMissionStartExecuting(_ mission: DJIWaypointMission, missionIndex: Int) {
        SVProgressHUD.showInfo(withStatus: "StartExecuting")
    }
    
    func waypointMissionDidStop(_ mission: DJIWaypointMission, error: Error?) {
        SVProgressHUD.showInfo(withStatus: "DidStop")
    }
    
    func waypointMissionDidPaused(_ mission: DJIWaypointMission) {
        SVProgressHUD.showInfo(withStatus: "DidPaused")
    }
    
    func waypointMissionDidFinished() {
        SVProgressHUD.showInfo(withStatus: "DidFinished")
    }
    
    func waypointMissionExecuting(_ mission: DJIWaypointMission, executionEvent: DJIWaypointMissionExecutionEvent) {
        waypointIndex.text = String(extraWaypointMission!.targetWaypointIndex)
    }
    
}
