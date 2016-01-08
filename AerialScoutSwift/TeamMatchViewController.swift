//
//  TeamMatchViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class TeamMatchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var teamNumberField:UITextField?
    @IBOutlet weak var matchNumberField:UITextField?
    @IBOutlet weak var noShowButton:UIButton?
    @IBOutlet weak var alliance:UISegmentedControl?
    
    var currentMatch:Match? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamNumberField?.delegate = self
        matchNumberField?.delegate = self
        
        //teamNumberField?.keyboardType = .
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
    
    // UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return (currentMatch?.finalResult != 3)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationItem.leftBarButtonItem?.enabled = false
        noShowButton?.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField === teamNumberField {
            currentMatch?.teamNumber = Int((teamNumberField?.text)!)
        } else if textField === matchNumberField {
            currentMatch?.matchNumber = Int((matchNumberField?.text)!)
        }
        
        if (currentMatch?.matchNumber > 0 && currentMatch?.teamNumber > 0) {
            // Update Title View to include match and team number
        } else {
            // Update title view to show "New Match"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
