//
//  ScoutContainerViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class ScoutContainerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Controls for switching child views
    var viewButtons:UISegmentedControl?
    
    // Child View References -- (May not be necessary?)
    private var teamMatchView:TeamMatchViewController?
    private var autoView:AutoViewController?
    private var scoreView:ScoreViewController?
    private var teleopView:TeleopViewController?
    private var finalView:FinalViewController?
    private var scoutDataViews:[UIViewController?]? = nil
    
    // Reference of the Active Child View Controller and index within array
    private var activeViewController:UIViewController? = nil
    private var lastActiveViewIdx = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        // Setup first child view -- Will change to make dynamic
        activeViewController = teamMatchView
        viewButtons?.selectedSegmentIndex = 0
        
        self.navigationController?.toolbarHidden = false
        
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([teamMatchView!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func viewChange(control:UISegmentedControl) {
        //if(lastActiveViewIdx == control.selectedSegmentIndex) {return}
        lastActiveViewIdx = self.indexOfViewController(self.viewControllers![0])
        activeViewController = scoutDataViews![control.selectedSegmentIndex]
        let direction = (lastActiveViewIdx < control.selectedSegmentIndex) ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse
        self.setViewControllers([activeViewController!], direction: direction, animated: true, completion: nil)
    }
    
    // UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //print("didFinishAnimating: \(finished), PreviousViewController: \(previousViewControllers[0]), Transition Completed: \(completed)")
        if(completed) {
            lastActiveViewIdx = (viewButtons?.selectedSegmentIndex)!
            viewButtons?.selectedSegmentIndex = self.indexOfViewController(self.viewControllers![0])
        }
    }
    
    
    // UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (viewController === autoView) {
            return teamMatchView
        } else if (viewController === scoreView) {
            return autoView
        } else if (viewController === teleopView) {
            return scoreView
        } else if (viewController === finalView) {
            return teleopView
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (viewController === teamMatchView) {
            return autoView
        } else if (viewController === autoView) {
            return scoreView
        } else if (viewController === scoreView) {
            return teleopView
        } else if (viewController === teleopView) {
            return finalView
        }
        return nil
    }
    
    func indexOfViewController(vc:UIViewController) -> Int {
        return (vc === teamMatchView) ? 0 :
               (vc === autoView)      ? 1 :
               (vc === scoreView)     ? 2 :
               (vc === teleopView)    ? 3 :
               (vc === finalView)     ? 4 : -1
    }
}
