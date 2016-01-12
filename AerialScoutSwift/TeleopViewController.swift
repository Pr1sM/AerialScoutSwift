//
//  TeleopViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class TeleopViewController: ScoutDataViewController {
    
    // MARK: - IB Variables
    
    @IBOutlet weak var drivingQuality:ReselectableSegmentedControl!
    @IBOutlet weak var travelSpeed:ReselectableSegmentedControl!
    @IBOutlet weak var defenseAbility:ReselectableSegmentedControl!
    @IBOutlet weak var pickupSpeed:ReselectableSegmentedControl!
    @IBOutlet weak var inboundingSpeed:ReselectableSegmentedControl!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSegments()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func segmentDidChange(sender:UISegmentedControl) {
        if(sender === drivingQuality) {
            if self.currentMatch.teleDriveQuality == (sender.selectedSegmentIndex + 1) {
                self.currentMatch.teleDriveQuality = 0
                sender.selectedSegmentIndex = UISegmentedControlNoSegment
            } else {
                self.currentMatch.teleDriveQuality = (sender.selectedSegmentIndex + 1)
            }
        } else if sender === travelSpeed {
            if self.currentMatch.teleTravelSpeed == (sender.selectedSegmentIndex + 1) {
                self.currentMatch.teleTravelSpeed = 0
                sender.selectedSegmentIndex = UISegmentedControlNoSegment
            } else {
                self.currentMatch.teleTravelSpeed = (sender.selectedSegmentIndex + 1)
            }
        } else if sender === defenseAbility {
            if self.currentMatch.teleDefenseAbility == (sender.selectedSegmentIndex + 1) {
                self.currentMatch.teleDefenseAbility = 0
                sender.selectedSegmentIndex = UISegmentedControlNoSegment
            } else {
                self.currentMatch.teleDefenseAbility = (sender.selectedSegmentIndex + 1)
            }
        } else if sender === pickupSpeed {
            if self.currentMatch.telePickupSpeed == (sender.selectedSegmentIndex + 1) {
                self.currentMatch.telePickupSpeed = 0
                sender.selectedSegmentIndex = UISegmentedControlNoSegment
            } else {
                self.currentMatch.telePickupSpeed = (sender.selectedSegmentIndex + 1)
            }
        } else if sender === inboundingSpeed {
            if self.currentMatch.teleInboundSpeed == (sender.selectedSegmentIndex + 1) {
                self.currentMatch.teleInboundSpeed = 0
                sender.selectedSegmentIndex = UISegmentedControlNoSegment
            } else {
                self.currentMatch.teleInboundSpeed = (sender.selectedSegmentIndex + 1)
            }
        }
    }
    
    // MARK: - Private Methods
    
    func setupSegments() {
        drivingQuality.selectedSegmentIndex = (self.currentMatch.teleDriveQuality! >= 1) ? (self.currentMatch.teleDriveQuality! - 1) : UISegmentedControlNoSegment
        travelSpeed.selectedSegmentIndex = (self.currentMatch.teleTravelSpeed! >= 1) ? (self.currentMatch.teleTravelSpeed! - 1) : UISegmentedControlNoSegment
        defenseAbility.selectedSegmentIndex = (self.currentMatch.teleDefenseAbility! >= 1) ? (self.currentMatch.teleDefenseAbility! - 1) : UISegmentedControlNoSegment
        pickupSpeed.selectedSegmentIndex = (self.currentMatch.telePickupSpeed! >= 1) ? (self.currentMatch.telePickupSpeed! - 1) : UISegmentedControlNoSegment
        inboundingSpeed.selectedSegmentIndex = (self.currentMatch.teleInboundSpeed! >= 1) ? (self.currentMatch.teleInboundSpeed! - 1) : UISegmentedControlNoSegment
    }
    
    // MARK: - Internal Methods
    
    
}
