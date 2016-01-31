//
//  LabeledStepper.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 1/16/16.
//  Copyright © 2016 dhanwada. All rights reserved.
//

import UIKit

protocol LabeledStepperDelegate {
    func stepView(stepper:LabeledStepper, stepValueDidChange value:Int)
}

class LabeledStepper: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var plus:UIButton!
    @IBOutlet var minus:UIButton!
    @IBOutlet var name:UILabel!
    @IBOutlet var status:UILabel!
    
    var tag:Int
    
    var countValue:Int {
        didSet {
            if(countValue > maxValue) { self.countValue = maxValue }
            if(countValue < minValue) { self.countValue = minValue }
            
            status.text = "\(self.countValue)"
            
            minus.enabled = (countValue > minValue)
            plus.enabled = (countValue < maxValue)
            
            if(countValue > minValue) {
                status.textColor = UIColor.orangeColor()
                status.backgroundColor = UIColor.darkGrayColor()
            } else {
                status.textColor = UIColor.whiteColor()
                status.backgroundColor = UIColor.lightGrayColor()
            }
        }
    }
    
    var maxValue:Int {
        didSet {
            if(countValue > maxValue) { countValue = maxValue }
            else {
                minus.enabled = (countValue > minValue)
                plus.enabled = (countValue < maxValue)
                status.backgroundColor = (countValue > minValue) ? UIColor.blackColor() : UIColor.lightGrayColor()
            }
        }
    }
    
    var minValue:Int = 0
    
    var delegate:LabeledStepperDelegate?
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        self.maxValue = 0
        self.countValue = 0
        self.tag = 0
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.layer.cornerRadius = 5.0
        status.clipsToBounds = true
        plus.layer.cornerRadius = 5.0
        minus.layer.cornerRadius = 5.0
    }
    
    // MARK: - IBActions
    
    @IBAction func minusTap(sender:UIButton) {
        self.countValue--
        if let d:LabeledStepperDelegate = delegate {
            d.stepView(self, stepValueDidChange: -1)
        }
    }
    
    @IBAction func plusTap(sender:UIButton) {
        self.countValue++
        if let d:LabeledStepperDelegate = delegate {
            d.stepView(self, stepValueDidChange: 1)
        }
    }
}
