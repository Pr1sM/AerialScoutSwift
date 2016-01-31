//
//  ScoreViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//
// Match Cycle Data
//
// Bit: 0   Completed       (0=No; 1=Yes)
//      1   Ball Type       (0=Teleop; 1=Auto)
//      2   Assist          (0=No; 1=Yes)
//      3   Truss Pass      (0=No; 1=Yes)
//      4   Truss Catch     (0=No; 1=Yes)
//      5   High Goal       (0=No; 1=Yes)
//      6   Low Goal        (0=No; 1=Yes)
//    7-8   Total Assists   (0=1; 1=2; 2=3)

import UIKit

class ScoreViewController: ScoutDataViewController, LabeledStepperDelegate {
    
    @IBOutlet var stackView:UIStackView!
    
    @IBOutlet var trussPass:UIButton!
    @IBOutlet var trussCatch:UIButton!
    @IBOutlet var assist:UIButton!
    @IBOutlet var assistLabel:UILabel!
    
    @IBOutlet var cycleComplete:UIButton!
    @IBOutlet var nextCycle:UIButton!
    @IBOutlet var prevCycle:UIButton!
    @IBOutlet var cycleLabel:UILabel!
    
    @IBOutlet var ballType:UISegmentedControl!
    @IBOutlet var goalType:ReselectableSegmentedControl!
    
    @IBOutlet var assistImage:UIImageView!
    
    var ballDrop:LabeledStepper!
    var highGoalMiss:LabeledStepper!
    var trussPassMiss:LabeledStepper!
    var steppers:[LabeledStepper]!
    
    var currentCycleData:Int
    var currentCycleIndex:Int
    var newCycleData:Bool
    var cancelEdit:Bool
    
    // MARK: Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        currentCycleData = 0
        currentCycleIndex = 0
        newCycleData = false
        cancelEdit = false
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let board = UIStoryboard(name: "Support", bundle: nil)
        
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .EqualCentering
        
        ballDrop = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(ballDrop)
        stackView.addArrangedSubview(ballDrop.view)
        ballDrop.didMoveToParentViewController(self)
        
        highGoalMiss = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(highGoalMiss)
        stackView.addArrangedSubview(highGoalMiss.view)
        highGoalMiss.didMoveToParentViewController(self)
        
        trussPassMiss = board.instantiateViewControllerWithIdentifier("LabeledStepper") as! LabeledStepper
        self.addChildViewController(trussPassMiss)
        stackView.addArrangedSubview(trussPassMiss.view)
        trussPassMiss.didMoveToParentViewController(self)
        
        steppers = [ballDrop, highGoalMiss, trussPassMiss]
        let names = ["Ball Drop:", "High Goal Miss:", "Truss Pass Miss:"]
        
        var tag = 0
        for step in steppers {
            step.delegate = self
            step.minValue = 0
            step.maxValue = 100
            step.name.text = names[tag]
            step.tag = ++tag
            step.status.layer.cornerRadius = 5.0
        }
        
        cycleComplete.layer.cornerRadius = 5.0
        nextCycle.layer.cornerRadius = 5.0
        prevCycle.layer.cornerRadius = 5.0
        
        currentCycleData = 0
        currentCycleIndex = 0
        newCycleData = true
        
        let imageTap = UITapGestureRecognizer(target: self, action: "assistImageTap:")
        assistImage.addGestureRecognizer(imageTap)
        assistImage.multipleTouchEnabled = false
        assistImage.userInteractionEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (currentMatch.isCompleted & 4) == 0 {
            currentMatch.isCompleted |= 4
            isComplete()
        }
        
        currentCycleData = self.getCycleData(currentCycleIndex)
        newCycleData = false
        cancelEdit = false
        
        ballDrop.countValue = currentMatch.scoreDrops
        highGoalMiss.countValue = currentMatch.scoreMissedHigh
        trussPassMiss.countValue = currentMatch.scoreMissedTruss
        
        self.showCycleData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !cancelEdit {
            self.sumCycleData()
        }
    }
    
    // MARK: Internal Methods
    
    func assistImageTap(sender:UIGestureRecognizer) {
        let location = sender.locationInView(assistImage)
        let width = assistImage.frame.width
        let index = (location.x <= width/3) ? 0 : (location.x <= (2*width)/3) ? 1 : 2
        currentCycleData = (currentCycleData & 127) + (index * 128)
        var startImage:UIImage? = nil
        if(currentMatch.alliance == 0) {
            startImage = UIImage(named: ((index == 1) ? "red2Assist" : (index == 2) ? "red3Assist" : "red1Assist"))
        } else {
            startImage = UIImage(named: ((index == 1) ? "blue2Assist" : (index == 2) ? "blue3Assist" : "blue1Assist"))
        }
        assistImage.image = startImage
        if(index == 2) {
            currentCycleData |= 4
            assist.selected = true
        }
        
        newCycleData = true
    }
    
    // MARK: Private Methods
    
    private func getCycleData(index:Int) -> Int {
        if(index >= currentMatch.cycles.count || index < 0) {
            return 0
        }
        
        return currentMatch.cycles[index]
    }
    
    private func putCycleData(data:Int, atIndex index:Int) {
        if(index >= currentMatch.cycles.count || index < 0 || data < 0 || data > 511) {
            return
        }
        currentMatch.cycles[index] = data
    }
    
    private func showCycleData() {
        // goal type
        if(currentCycleData & 32) == 32 {
            goalType.selectedSegmentIndex = 0
        } else if (currentCycleData & 64) == 64 {
            goalType.selectedSegmentIndex = 1
        } else {
            goalType.selectedSegmentIndex = -1
        }
        
        goalType.selectedSegmentIndex = ((currentCycleData & 32) == 32) ? 0 :
                                        ((currentCycleData & 64) == 64) ? 1 : -1
        
        cycleComplete.enabled = true
        
        if (currentCycleData & 2) == 0 { // Teleop Ball
            
            assistLabel.textColor = UIColor.blackColor()
            
            // Assist Button
            assist.selected = (currentCycleData & 4) == 4
            assist.enabled = true
            
            // Truss Catch
            trussCatch.selected = (currentCycleData & 16) == 16
            trussCatch.enabled = true
            
            // Truss Pass
            trussPass.selected = (currentCycleData & 8) == 8
            trussPass.enabled = true
            
            trussPassMiss.minus.enabled = trussPassMiss.countValue > trussPassMiss.minValue
            trussPassMiss.plus.enabled = trussPassMiss.countValue < trussPassMiss.maxValue
        } else { // Auto Ball
            
            assistLabel.textColor = UIColor.darkGrayColor()
            
            // Assist Button
            assist.selected = false
            assist.enabled = false
            
            // Truss Catch
            trussCatch.selected = false
            trussCatch.enabled = false
            
            // Truss Pass
            trussPass.selected = false
            trussPass.enabled = false
            
            trussPassMiss.plus.enabled = false
            trussPassMiss.minus.enabled = false
        }
        
        if (currentCycleData & 1) == 0 {
            cycleLabel.text = "New (\(currentCycleIndex+1))"
        } else {
            cycleLabel.text = "\(currentCycleIndex+1) of \(currentMatch.cycles.count + 1)"
        }
        
        ballType.selectedSegmentIndex = ((currentCycleData & 2) == 2) ? 0 : 1
        
        var startImage:UIImage? = nil
        let allianceAssists = currentCycleData >> 7
        if(currentMatch.alliance == 0) {
            startImage = UIImage(named: ((allianceAssists == 1) ? "red2Assist" : (allianceAssists == 2) ? "red3Assist" : "red1Assist"))
        } else {
            startImage = UIImage(named: ((allianceAssists == 1) ? "blue2Assist" : (allianceAssists == 2) ? "blue3Assist" : "blue1Assist"))
        }
        assistImage.image = startImage!
        
        prevCycle.enabled = currentCycleIndex > 0
        nextCycle.enabled = currentCycleIndex < currentMatch.cycles.count
        
        if (currentCycleIndex != currentMatch.cycles.count) {
            cycleComplete.setTitle("Delete Cycle", forState: .Normal)
        } else {
            cycleComplete.setTitle("Finish Cycle", forState: .Normal)
        }
    }
    
    private func sumCycleData() {
        currentMatch.scoreDrops = ballDrop.countValue
        currentMatch.scoreMissedHigh = highGoalMiss.countValue
        currentMatch.scoreMissedTruss = trussPassMiss.countValue
        
        if(!newCycleData) {return}
        
        newCycleData = false
        self.putCycleData(currentCycleData, atIndex: currentCycleIndex)
        
        currentMatch.scoreAssists = 0
        currentMatch.scoreCycles       = 0;
        currentMatch.scoreHigh         = 0;
        currentMatch.scoreLow          = 0;
        currentMatch.scoreTeamAssist1  = 0;
        currentMatch.scoreTeamAssist2  = 0;
        currentMatch.scoreTeamAssist3  = 0;
        currentMatch.scoreTrussCatch   = 0;
        currentMatch.scoreTrussPass    = 0;
        
        for var i = 0; i < currentMatch.cycles.count; ++i {
            let data = self.getCycleData(i)
            
            if (data & 8) == 8 { currentMatch.scoreTrussPass++ }
            if (data & 16) == 16 { currentMatch.scoreTrussCatch++ }
            
            if (data & 1) == 1 { // Cycle Completed
                if (data & 2) == 0 { currentMatch.scoreCycles++ }
                if (data & 32) == 32 { currentMatch.scoreHigh++ }
                if (data & 64) == 64 { currentMatch.scoreLow++ }
                
                if (data & 4) == 4 { // Contributed Assist
                    currentMatch.scoreAssists++
                    
                    switch (data >> 7) {
                    case 0: currentMatch.scoreTeamAssist1++; break;
                    case 1: currentMatch.scoreTeamAssist2++; break;
                    case 2: currentMatch.scoreTeamAssist3++; break;
                    default: break;
                    }
                }
            }
        }
    }
    
    // MARK: IBActions
    
    @IBAction func ballTypeChanged(sender:UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            currentCycleData = (currentCycleData & 97) | 2
        } else {
            currentCycleData = (currentCycleData & 97)
        }
        
        self.showCycleData()
    }
    
    @IBAction func cycleCompleteTap(sender:UIButton) {
        if (currentCycleData & 1) == 0 {
            let actionSheet = UIAlertController(title: "Cycle Completed", message: "What happened?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            actionSheet.addAction(cancelAction)
            
            let deadBallAction = UIAlertAction(title: "Dead Ball", style: .Default, handler: {(action) in
                self.currentCycleData &= 27
                self.showCycleData()
            })
            actionSheet.addAction(deadBallAction)
            
            let ballScoredAction = UIAlertAction(title: "Ball Scored", style: .Default, handler: {(action) in
                self.currentCycleData |= 1
                self.currentMatch.cycles.append(self.currentCycleData)
                self.currentCycleIndex++
                self.currentCycleData = self.getCycleData(self.currentCycleIndex)
                
                self.showCycleData()
            })
            actionSheet.addAction(ballScoredAction)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        } else {
            let actionSheet = UIAlertController(title: "Delete Cycle", message: "Are you sure?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            actionSheet.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) in
                self.currentMatch.cycles.removeAtIndex(self.currentCycleIndex)
                self.currentCycleData = self.getCycleData(self.currentCycleIndex)
                self.showCycleData()
            })
            actionSheet.addAction(deleteAction)
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func goalTypeButtonTap(sender:UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            currentCycleData = ((currentCycleData & 32) == 32) ? currentCycleData ^ 32 : (currentCycleData & 415) | 32
        } else {
            currentCycleData = ((currentCycleData & 64) == 64) ? currentCycleData ^ 64 : (currentCycleData & 415) | 64
        }
        
        newCycleData = true
    }
    
    @IBAction func nextCycleTap(sender:UIButton) {
        self.putCycleData(currentCycleData, atIndex: currentCycleIndex)
        currentCycleIndex++
        currentCycleData = self.getCycleData(currentCycleData)
        self.showCycleData()
    }
    
    @IBAction func prevCycleTap(sender:UIButton) {
        self.putCycleData(currentCycleData, atIndex: currentCycleIndex)
        currentCycleIndex--
        currentCycleData = self.getCycleData(currentCycleData)
        self.showCycleData()
    }
    
    @IBAction func trussPassTap(sender:UIButton) {
        if (currentCycleData & 8) == 8 {
            currentCycleData ^= 8
        } else {
            currentCycleData |= 8
        }
        
        sender.selected = (currentCycleData & 8) == 8
        newCycleData = true
    }
    
    @IBAction func trussCatchTap(sender:UIButton) {
        if (currentCycleData & 16) == 16 {
            currentCycleData ^= 16
        } else {
            currentCycleData |= 16
        }
        
        sender.selected = (currentCycleData & 16) == 16
        newCycleData = true
    }
    
    @IBAction func teamAssistTap(sender:UIButton) {
        if (currentCycleData & 4) == 4 {
            currentCycleData ^= 4
        } else {
            currentCycleData |= 4
        }
        
        sender.selected = (currentCycleData & 4) == 4
        newCycleData = true
    }
    
    // MARK: LabeledStepperDelegate
    
    func stepView(stepper: LabeledStepper, stepValueDidChange value: Int) {
        
    }
}
