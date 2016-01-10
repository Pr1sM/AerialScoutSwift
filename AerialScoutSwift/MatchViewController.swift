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
        self.navigationItem.titleView = UIView(frame: CGRectZero)
        titleView?.view.center.x = (self.navigationController?.navigationBar.center.x)!
        self.navigationController?.toolbar.barTintColor = UIColor.orangeColor()
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.changeToolbars(self.editing, animated: animated)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.titleView?.matchLabel?.text = (self.editing) ? "Edit List" : "Scouting List"
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.titleView?.matchLabel?.text = (self.editing) ? "Edit List" : "Scouting List"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        titleView?.view.removeFromSuperview()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
        self.titleView?.matchLabel?.text = (editing) ? "Edit List" : "Scouting List"
    }
    
    // Table View Delegate and Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Matches"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (MatchStore.sharedStore.allMatches?.count)!
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchViewCell") as! MatchViewCell
        
        let match = MatchStore.sharedStore.allMatches?[indexPath.row]
        
        cell.accessoryType = .DisclosureIndicator
        
        let matchNumber:Int = match!.matchNumber!
        let teamNumber:Int = match!.teamNumber!
        
        cell.matchNumberLabel?.text = "\(matchNumber)"
        cell.teamNumberLabel?.text = "\(teamNumber)"
        cell.checkmarkImage?.hidden = (match?.isCompleted! != 31)
        
        return cell
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