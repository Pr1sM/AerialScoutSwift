//
//  MatchViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/19/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class MatchViewController : UITableViewController {
    
    @IBOutlet weak var editToolbar : UIToolbar?
    @IBOutlet weak var mainToolbar : UIToolbar?
    
    var titleView:TitleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBarHidden = false
        self.setToolbarItems(mainToolbar?.items, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        titleView = storyboard.instantiateViewControllerWithIdentifier("TitleView") as? TitleView
        titleView?.matchLabel?.text = ""
        titleView?.view.frame = CGRect(x: 0, y: 5.5, width: 150, height: 33)
        //self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        //self.navigationItem.title = "Scouting List"
        self.navigationItem.titleView = UIView(frame: CGRectZero)
        titleView?.view.center.x = (self.navigationController?.navigationBar.center.x)!
        self.navigationController?.toolbar.barTintColor = UIColor.orangeColor()
        self.hidesBottomBarWhenPushed = false
        //print(titleView?.view.center)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.changeToolbars(self.editing, animated: animated)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        //print("Match View Will Appear: \(animated)")
        //if(animated == false) {
            self.titleView?.matchLabel?.text = (self.editing) ? "Edit List" : "Scouting List"
        //}
        
        //print("Match View will Appear: \(animated)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.titleView?.matchLabel?.text = (self.editing) ? "Edit List" : "Scouting List"
        
        //print("Match View did Appear: \(animated)")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setToolbarHidden(true, animated: true)
        titleView?.view.removeFromSuperview()
        //print("Match View will disappear: \(animated)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //titleView?.view.removeFromSuperview()
        //print("Match View did disappear: \(animated)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
        self.navigationItem.rightBarButtonItem?.enabled = !editing
        self.changeToolbars(editing, animated: animated)
    }
    
    func changeToolbars(editing: Bool, animated: Bool) {
        self.setToolbarItems((editing ? editToolbar?.items : mainToolbar?.items), animated: animated)
        //if(animated == false) {
            self.titleView?.matchLabel?.text = (editing) ? "Edit List" : "Scouting List"
        //}
    }
    
    // Table View Delegate and Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Matches"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MatchStore.sharedStore.allMatches?.count)!
    }
    
    // Segue Logic
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToNewMatch" {
            let navController = segue.destinationViewController as! UINavigationController
            let dataView = navController.viewControllers[0] as! ScoutContainerViewController
            dataView.sourceNavigationController = self.navigationController
        }
    }
    
    // Unwind Segue
    @IBAction func unwindToSummary(sender:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindCancelToMatchList(sender:UIStoryboardSegue) {
        
    }
}