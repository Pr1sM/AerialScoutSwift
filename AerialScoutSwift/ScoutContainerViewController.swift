//
//  ScoutContainerViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class ScoutContainerViewController: UIViewController {
    
    // Parent's Content View that children's view will inhabit
    @IBOutlet var contentView:UIView?
    
    // Controls for switching child views
    var viewButtons:UISegmentedControl?
    
    // Child View References -- (May not be necessary?)
    private var teamMatchView:TeamMatchViewController?
    private var autoView:AutoViewController?
    private var scoreView:ScoreViewController?
    private var teleopView:TeleopViewController?
    private var finalView:FinalViewController?
    private var scoutDataViews:[UIViewController?]? = nil
    
    // Frames for child view animation changes
    private var leftViewFrame:CGRect = CGRectZero
    private var rightViewFrame:CGRect = CGRectZero
    
    // Reference of the Active Child View Controller and index within array
    private var activeViewController:UIViewController?
    private var lastActiveViewIdx = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.activeViewController = nil
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.activeViewController = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Navigation Toolbar
        let labels = ["Match", "Auto", "Score", "Teleop", "Final"]
        viewButtons = UISegmentedControl(items: labels)
        viewButtons?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        viewButtons?.addTarget(self, action: "viewChange:", forControlEvents: UIControlEvents.ValueChanged)
        viewButtons?.frame = CGRectMake(0, 0, self.view.frame.width - 30, 30)
        let viewItem = UIBarButtonItem(customView: viewButtons!)
        self.toolbarItems = [viewItem]
        
        // Setup child view controllers
        teamMatchView = self.storyboard?.instantiateViewControllerWithIdentifier("TeamMatchViewController") as? TeamMatchViewController
        autoView = self.storyboard?.instantiateViewControllerWithIdentifier("AutoViewController") as? AutoViewController
        scoreView = self.storyboard?.instantiateViewControllerWithIdentifier("ScoreViewController") as? ScoreViewController
        teleopView = self.storyboard?.instantiateViewControllerWithIdentifier("TeleopViewController") as? TeleopViewController
        finalView = self.storyboard?.instantiateViewControllerWithIdentifier("FinalViewController") as? FinalViewController
        scoutDataViews = [(teamMatchView)!, (autoView)!, (scoreView)!, (teleopView)!, (finalView)!]
        
        // Setup left and right frames for animation
        leftViewFrame = CGRectMake((contentView?.frame.origin.x)! - (contentView?.frame.width)!, (contentView?.frame.origin.y)!, (contentView?.frame.width)!, (contentView?.frame.height)!)
        rightViewFrame = CGRectMake((contentView?.frame.origin.x)! + (contentView?.frame.width)!, (contentView?.frame.origin.y)!, (contentView?.frame.width)!, (contentView?.frame.height)!)
        
        // Setup first child view
        activeViewController = teamMatchView
        viewButtons?.selectedSegmentIndex = 0
        displayContentController(activeViewController!)
        self.navigationController?.toolbarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func viewChange(control:UISegmentedControl) {
        activeViewController = scoutDataViews![control.selectedSegmentIndex]
        self.cycleFromViewControllerIdx(lastActiveViewIdx, toNewViewControllerIdx: control.selectedSegmentIndex)
        lastActiveViewIdx = control.selectedSegmentIndex
        
    }
    
    func displayContentController(content:UIViewController) {
        self.addChildViewController(content)
        content.view.frame = (contentView?.frame)!
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    func hideContentController(content:UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    func cycleFromViewController(oldVC:UIViewController, toNewViewController newVC:UIViewController) {
        oldVC.willMoveToParentViewController(nil)
        self.addChildViewController(newVC)
        
        newVC.view.frame = self.leftViewFrame
        let CGRectEndFrame = self.rightViewFrame
        
        self.transitionFromViewController(oldVC, toViewController: newVC, duration: 0.25, options: UIViewAnimationOptions.TransitionNone, animations: {() in
                newVC.view.frame = oldVC.view.frame
                oldVC.view.frame = CGRectEndFrame
            }, completion: {(finished:Bool) in
                oldVC.removeFromParentViewController()
                newVC.didMoveToParentViewController(self)
            })
    }
    
    func cycleFromViewControllerIdx(oldVCIdx:Int, toNewViewControllerIdx newVCIdx:Int) {
        if (oldVCIdx == newVCIdx) {return}
        
        let oldVC:UIViewController = scoutDataViews![oldVCIdx]!
        let newVC:UIViewController = scoutDataViews![newVCIdx]!
        
        oldVC.willMoveToParentViewController(nil)
        self.addChildViewController(newVC)
        
        let CGRectStartFrame = (newVCIdx < oldVCIdx) ? leftViewFrame : rightViewFrame
        let CGRectEndFrame = (newVCIdx < oldVCIdx) ? rightViewFrame : leftViewFrame
        newVC.view.frame = CGRectStartFrame
        
        
        self.transitionFromViewController(oldVC, toViewController: newVC, duration: 0.25, options: UIViewAnimationOptions.CurveEaseIn, animations: {() in
            newVC.view.frame = oldVC.view.frame
            oldVC.view.frame = CGRectEndFrame
            }, completion: {(finished:Bool) in
                oldVC.removeFromParentViewController()
                newVC.didMoveToParentViewController(self)
        })
    }
}
