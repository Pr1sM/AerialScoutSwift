//
//  TeamMatchViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class TeamMatchViewController: ScoutDataViewController, UITextFieldDelegate {
    
    // MARK: - IB Variables
    
    @IBOutlet weak var teamNumberField:TextFieldAccessoryView!
    @IBOutlet weak var matchNumberField:TextFieldAccessoryView!
    @IBOutlet weak var noShowButton:UIButton!
    @IBOutlet weak var alliance:UISegmentedControl!
    
    var activeField:UITextField?
    
    private var disableView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamNumberField?.delegate = self
        matchNumberField?.delegate = self
        
        teamNumberField?.keyboardType = .NumberPad
        matchNumberField?.keyboardType = .NumberPad
        
        // Setup transition disabling when team match view is not complete
        let disableGesture = UIPanGestureRecognizer(target: self, action: "disablePan:")
        disableView.addGestureRecognizer(disableGesture)
        self.view.addSubview(disableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.isComplete()
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
    
    // MARK: - IBActions
    
    @IBAction func allianceDidChange(sender:AnyObject) {
        let seg = sender as! UISegmentedControl
        currentMatch.alliance = seg.selectedSegmentIndex
        if let field:UITextField = activeField {
            field.resignFirstResponder()
        }
        self.isComplete()
    }
    
    // MARK: - Misc Methods
    
    func disablePan(sender:UIPanGestureRecognizer) {
        switch (sender.state) {
        case .Began:
        let velocity = sender.velocityInView(sender.view)
        if fabs(velocity.y) < fabs(velocity.x) {
            if velocity.x < 0 {
                if ((self.currentMatch.isCompleted & 1) != 1) {
                    self.presentAlertCannotCompleteAction()
                    return
                }
            }
        }
        break
        default:
        break
        }
    }
    
    func closeTextFields() {
        matchNumberField?.resignFirstResponder()
        teamNumberField?.resignFirstResponder()
    }
    
    private func presentAlertCannotCompleteAction() {
        let alert = UIAlertController(title: "Uh-oh!", message: "In order to complete the action specified, you must complete the required fields first", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func isComplete() {
        if currentMatch.teamNumber >= 1 && currentMatch.matchNumber >= 1 && currentMatch.alliance >= 0 {
            currentMatch.isCompleted |= 1;
        } else if (currentMatch.isCompleted & 1) == 1 {
            currentMatch.isCompleted ^= 1;
        }
        let viewComplete:Bool = (self.currentMatch.isCompleted & 1) != 0
        disableView.userInteractionEnabled = !viewComplete
        super.isComplete()
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return (currentMatch.finalResult != 3)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        container?.navigationItem.rightBarButtonItem?.enabled = false
        container?.navigationItem.leftBarButtonItem?.enabled = false
        noShowButton?.enabled = false
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let match:Match = currentMatch {
            if textField === teamNumberField {
                if(teamNumberField.text?.characters.count > 0) {
                    match.teamNumber = Int((teamNumberField?.text)!) ?? match.teamNumber
                }
            } else if textField === matchNumberField {
                if(matchNumberField.text?.characters.count > 0) {
                    match.matchNumber = Int((matchNumberField?.text)!) ?? match.matchNumber
                }
            }
            
            if (currentMatch.matchNumber > 0 && currentMatch.teamNumber > 0) {
                // Update Title View to include match and team number
                container?.titleView?.matchLabel?.text = "Match \(match.matchNumber) : \(match.teamNumber)"
            } else {
                // Update title view to show "New Match"
                container?.titleView?.matchLabel?.text = "New Match"
            }
            self.isComplete()
            container?.navigationItem.rightBarButtonItem?.enabled = true
            container?.navigationItem.leftBarButtonItem?.enabled = true
        }
        activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.isComplete()
        return false
    }
}
