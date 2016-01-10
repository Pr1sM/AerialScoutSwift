//
//  ScoutContainerViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/28/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class ScoutContainerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    // MARK: - Variables
    var viewButtons:UISegmentedControl?
    var sourceNavigationController:UINavigationController? = nil
    
    // Child View References -- (May not be necessary?)
    private var teamMatchView:TeamMatchViewController?
    private var autoView:AutoViewController?
    private var scoreView:ScoreViewController?
    private var teleopView:TeleopViewController?
    private var finalView:FinalViewController?
    private var scoutDataViews:[ScoutDataViewController?]? = nil
    
    // Reference of the Active Child View Controller and index within array
    private var activeViewController:ScoutDataViewController? = nil
    private var lastActiveViewIdx = 0
    
    var titleView:TitleView?
    var editMatch:Match = Match()
    var origMatch:Match?
    
    
    
    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
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
        self.navigationController?.toolbar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.barTintColor = UIColor.orangeColor()
        
        // Setup child view controllers
        let storyboard = UIStoryboard(name: "ScoutDataViews", bundle: nil)
        teamMatchView = storyboard.instantiateViewControllerWithIdentifier("TeamMatchViewController") as? TeamMatchViewController
        autoView = storyboard.instantiateViewControllerWithIdentifier("AutoViewController") as? AutoViewController
        scoreView = storyboard.instantiateViewControllerWithIdentifier("ScoreViewController") as? ScoreViewController
        teleopView = storyboard.instantiateViewControllerWithIdentifier("TeleopViewController") as? TeleopViewController
        finalView = storyboard.instantiateViewControllerWithIdentifier("FinalViewController") as? FinalViewController
        scoutDataViews = [(teamMatchView)!, (autoView)!, (scoreView)!, (teleopView)!, (finalView)!]
        
        // Setup first child view -- Will change to make dynamic
        activeViewController = teamMatchView
        viewButtons?.selectedSegmentIndex = 0
        
        // Setup Title View
        titleView = self.storyboard!.instantiateViewControllerWithIdentifier("TitleView") as? TitleView
        titleView?.matchLabel?.text = ""
        titleView?.view.frame = CGRect(x: 0, y: 5.5, width: 150, height: 33)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.navigationItem.title = "New Match"
        self.navigationItem.titleView = UIView(frame: CGRectZero)
        titleView?.view.center.x = (self.navigationController?.navigationBar.center.x)!
        
        self.navigationController?.toolbarHidden = false
        self.hidesBottomBarWhenPushed = false
        
        self.dataSource = self
        self.delegate = self
        
        if(self.origMatch == nil) {
            self.origMatch = Match()
        }
        
        self.editMatch = Match(withCopy: self.origMatch!)
        
        // Change this to move to the correct view if match is in progress
        self.setViewControllers([activeViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.titleView?.matchLabel?.text = "New Match"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.titleView?.matchLabel?.text = "New Match"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Navigation Actions
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "SegueUnwindToSummary" {
            if ((self.editMatch.isCompleted! & 1) != 1) {
                self.presentAlertCannotCompleteAction()
                return false
            }
        }
        
        if activeViewController === teamMatchView {
            teamMatchView?.closeTextFields()
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueUnwindToSummary" {
            if MatchStore.sharedStore.containsMatch(self.origMatch) {
                MatchStore.sharedStore.replaceMatch(self.origMatch!, withNewMatch: self.editMatch)
            } else {
                MatchStore.sharedStore.addMatch(self.editMatch)
            }
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let summary = mainStoryboard.instantiateViewControllerWithIdentifier("MatchSummaryController")
            self.sourceNavigationController!.pushViewController(summary, animated: false)
        }
    }
    
    // MARK: - UISegmentedControl Selector
    
    func viewChange(control:UISegmentedControl) {
        if self.indexOfViewController(self.viewControllers![0]) == 0 {
            if ((self.editMatch.isCompleted! & 1) != 1) {
                control.selectedSegmentIndex = 0
                self.presentAlertCannotCompleteAction()
                return
            }
        }
        lastActiveViewIdx = self.indexOfViewController(self.viewControllers![0])
        activeViewController = scoutDataViews![control.selectedSegmentIndex]
        let direction = (lastActiveViewIdx < control.selectedSegmentIndex) ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse
        self.setViewControllers([activeViewController!], direction: direction, animated: true, completion: nil)
    }
    
    // MARK: - UIPageViewController Methods
    
    override func setViewControllers(viewControllers: [UIViewController]?, direction: UIPageViewControllerNavigationDirection, animated: Bool, completion: ((Bool) -> Void)?) {
        if viewControllers?.count == 1 {
            if viewControllers![0].isKindOfClass(ScoutDataViewController) {
                let dataView = viewControllers![0] as! ScoutDataViewController
                dataView.currentMatch = self.editMatch
                dataView.container = self
            }
        }
        super.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
    }
    
    // MARK: - UIPageViewControllerDelegate Methods
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed) {
            lastActiveViewIdx = (viewButtons?.selectedSegmentIndex)!
            viewButtons?.selectedSegmentIndex = self.indexOfViewController(self.viewControllers![0])
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let pendingView = pendingViewControllers[0]
        if pendingView.isKindOfClass(ScoutDataViewController) {
            let dataView = pendingView as! ScoutDataViewController
            dataView.currentMatch = self.editMatch
            dataView.container = self
        }
    }
    
    
    // MARK: - UIPageViewControllerDataSource Methods
    
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
    
    // MARK: - Internal Methods
    
    func isComplete() {
        if editMatch.teamNumber < 1 || editMatch.matchNumber < 1 || editMatch.alliance < 0 {
            editMatch.isCompleted! = ((self.editMatch.isCompleted! & 1) == 1) ? (self.editMatch.isCompleted! ^ 1) : editMatch.isCompleted!
            viewButtons?.setTitle("Match", forSegmentAtIndex: 0)
        } else {
            editMatch.isCompleted! |= 1
            viewButtons?.setTitle("MATCH", forSegmentAtIndex: 0)
        }
    }
    
    // MARK: - Private Methods
    
    private func indexOfViewController(vc:UIViewController) -> Int {
        return (vc === teamMatchView) ? 0 :
               (vc === autoView)      ? 1 :
               (vc === scoreView)     ? 2 :
               (vc === teleopView)    ? 3 :
               (vc === finalView)     ? 4 : -1
    }
    
    private func presentAlertCannotCompleteAction() {
        let alert = UIAlertController(title: "Uh-oh!", message: "In order to complete the action specified, you must complete the required fields first", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
