//
//  AutoViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class AutoViewController: ScoutDataViewController, LabeledStepperDelegate {
    
    //@IBOutlet var containerTest:UIView!
    @IBOutlet var stackView:UIStackView!
    @IBOutlet var startPosition:UISegmentedControl!
    @IBOutlet var move:UISegmentedControl!
    
    var hotHighStepper:LabeledStepper!
    var hotLowStepper:LabeledStepper!
    var highStepper:LabeledStepper!
    var lowStepper:LabeledStepper!
    var missedStepper:LabeledStepper!
    var steppers:[LabeledStepper]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        let board = UIStoryboard(name: "Support", bundle: nil)
        
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .EqualCentering
        
        hotHighStepper = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(hotHighStepper)
        stackView.addArrangedSubview(hotHighStepper.view)
        hotHighStepper.didMoveToParentViewController(self)
        
        highStepper = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(highStepper)
        stackView.addArrangedSubview(highStepper.view)
        highStepper.didMoveToParentViewController(self)
        
        hotLowStepper = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(hotLowStepper)
        stackView.addArrangedSubview(hotLowStepper.view)
        hotLowStepper.didMoveToParentViewController(self)
        
        lowStepper = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(lowStepper)
        stackView.addArrangedSubview(lowStepper.view)
        lowStepper.didMoveToParentViewController(self)
        
        missedStepper = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(missedStepper)
        stackView.addArrangedSubview(missedStepper.view)
        missedStepper.didMoveToParentViewController(self)
        
        steppers = [hotHighStepper, highStepper, hotLowStepper, lowStepper, missedStepper]
        let names = ["Hot High:", "High:", "Hot Low:", "Low:", "Missed:"]
        
        var tag = 0
        for step in steppers {
            step.delegate = self
            step.minValue = 0
            step.name.text = names[tag]
            step.tag = ++tag
            step.status.layer.cornerRadius = 5.0
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if((currentMatch.hasViewed & 2) == 0) {
            currentMatch.autoHotHigh = 0
            currentMatch.autoHigh    = 0
            currentMatch.autoHotLow  = 0
            currentMatch.autoLow     = 0
            currentMatch.autoMissed  = 0
            currentMatch.hasViewed |= 2
        }
        
        for step in steppers {
            step.maxValue = 3
        }
        
        hotHighStepper.countValue = currentMatch.autoHotHigh
        highStepper.countValue    = currentMatch.autoHigh
        hotLowStepper.countValue  = currentMatch.autoHotLow
        lowStepper.countValue     = currentMatch.autoLow
        missedStepper.countValue  = currentMatch.autoMissed
        
        setStepperLimits()
    }
    
    private func setStepperLimits() {
        for step1 in steppers {
            for step2 in steppers {
                if(step1 != step2) {
                    step1.maxValue = step1.maxValue - step2.countValue
                }
            }
        }
    }
    
    override func isComplete() {
        if (currentMatch.autoMoved >= 0 && currentMatch.autoStart >= 0) {
            currentMatch.isCompleted |= 2
        } else if (currentMatch.isCompleted & 2) == 2 {
            currentMatch.isCompleted ^= 2
        }
        super.isComplete()
    }
    
    // MARK: IBActions
    
    @IBAction func controlChanged(sender:UISegmentedControl) {
        if(sender === startPosition) {
            currentMatch.autoStart = sender.selectedSegmentIndex
        } else if(sender === move) {
            currentMatch.autoMoved = sender.selectedSegmentIndex
        }
        isComplete()
    }
    
    // MARK: LabeledStepperDelegate
    
    func stepView(stepper: LabeledStepper, stepValueDidChange value: Int) {
        for step in steppers {
            if(stepper !== step) {
                step.maxValue = step.maxValue - value
            }
        }
        
        switch(stepper.tag) {
        case 1:
            currentMatch.autoHotHigh = stepper.countValue
            break
        case 2:
            currentMatch.autoHigh = stepper.countValue
            break
        case 3:
            currentMatch.autoHotLow = stepper.countValue
            break
        case 4:
            currentMatch.autoLow = stepper.countValue
            break
        case 5:
            currentMatch.autoMissed = stepper.countValue
            break
        default:
            break
        }
    }
}
