//
//  FinalViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

import MultiSelectSegmentedControl

class FinalViewController: ScoutDataViewController, MultiSelectSegmentedControlDelegate, UITextFieldDelegate {
    
    // MARK: - IBOutlet Variables
    
    @IBOutlet weak var totalPointsNumberField:TextFieldAccessoryView!
    @IBOutlet weak var foulPointsNumberField:TextFieldAccessoryView!
    @IBOutlet weak var resultSegmentedControl:UISegmentedControl!
    @IBOutlet weak var robotOptions:MultiSelectSegmentedControl!
    @IBOutlet var penaltyButtons:[UIButton]!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalPointsNumberField.delegate = self
        foulPointsNumberField.delegate = self
        robotOptions.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    // MARK: - Internal Methods
    
    override func isComplete() {
        if(currentMatch.finalScore >= 0 && currentMatch.finalResult >= 0 && currentMatch.finalPenaltyScore >= 0) {
            currentMatch.isCompleted |= 16
        } else if (currentMatch.isCompleted & 16) == 16 {
            currentMatch.isCompleted ^= 16
        }
        super.isComplete()
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func resultTap(sender:UISegmentedControl) {
        if(sender === resultSegmentedControl) {
            currentMatch.finalResult = sender.selectedSegmentIndex
        }
        isComplete()
    }
    
    @IBAction func penaltyButtonTap(sender:UIButton) {
        let bitValue:Int = 1 << sender.tag
        var selected:Bool = false
        
        if (currentMatch.finalPenalty & bitValue) == bitValue {
            currentMatch.finalPenalty ^= bitValue
        } else {
            currentMatch.finalPenalty |= bitValue
            selected = true
        }
        
        if sender.tag == 2 {
            if (currentMatch.finalPenalty & 8) == 8 {
                currentMatch.finalPenalty ^= 8
                penaltyButtons[3].selected = false
            }
        } else if sender.tag == 3 {
            if (currentMatch.finalPenalty & 4) == 4 {
                currentMatch.finalPenalty ^= 4
                penaltyButtons[2].selected = false
            }
        }
        
        penaltyButtons[sender.tag].selected = selected
        isComplete()
    }
    
    // MARK: - MultiSelectSegmentedControlDelegate
    
    func multiSelect(multiSelecSegmendedControl: MultiSelectSegmentedControl!, didChangeValue value: Bool, atIndex index: UInt) {
        if multiSelecSegmendedControl === robotOptions {
            let bitValue:Int = 1 << Int(index)
            currentMatch.finalRobot += (value) ? bitValue : -1 * bitValue
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        container?.navigationItem.rightBarButtonItem?.enabled = false
        container?.navigationItem.leftBarButtonItem?.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let match:Match = currentMatch {
            if textField === totalPointsNumberField {
                if(totalPointsNumberField.text?.characters.count > 0) {
                    match.finalScore = Int(totalPointsNumberField.text!) ?? currentMatch.finalScore
                }
            } else if textField === foulPointsNumberField {
                if(foulPointsNumberField.text?.characters.count > 0) {
                    match.finalPenaltyScore = Int(foulPointsNumberField.text!) ?? currentMatch.finalPenaltyScore
                }
            }
            container?.navigationItem.rightBarButtonItem?.enabled = true
            container?.navigationItem.leftBarButtonItem?.enabled = true
        }
        isComplete()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
