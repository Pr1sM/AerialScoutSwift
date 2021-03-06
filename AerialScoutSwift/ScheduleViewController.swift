//
//  ScheduleViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/19/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class ScheduleViewController : UIViewController {
    
    private var titleView:TitleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        titleView = storyboard.instantiateViewControllerWithIdentifier("TitleView") as? TitleView
        titleView?.matchLabel?.text = ""
        titleView?.view.frame = CGRect(x: 0, y: 0, width: 150, height: 33)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.navigationItem.title = ""
        titleView?.view.center = (self.navigationController?.navigationBar.center)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleView?.matchLabel?.text = "Schedule"
    }
    
    @IBAction func done(sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}