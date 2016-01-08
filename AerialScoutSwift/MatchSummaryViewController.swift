//
//  MatchSummaryViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class MatchSummaryViewController: UIViewController {

    var titleView:TitleView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        titleView = self.storyboard!.instantiateViewControllerWithIdentifier("TitleView") as? TitleView
        titleView?.matchLabel?.text = ""
        titleView?.view.frame = CGRect(x: 0, y: 5.5, width: 150, height: 33)
        //self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.navigationItem.title = ""
        self.navigationItem.titleView = UIView(frame: CGRectZero)
        titleView?.view.center.x = (self.navigationController?.navigationBar.center.x)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.titleView?.matchLabel?.text = "Match Summary"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.titleView?.view.removeFromSuperview()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
