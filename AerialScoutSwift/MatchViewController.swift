//
//  MatchViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/19/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class MatchViewController : UITableViewController {
    
    @IBOutlet var editToolbar : UIToolbar?
    @IBOutlet var mainToolbar : UIToolbar?
    
    private var titleView:TitleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBarHidden = false
        self.setToolbarItems(mainToolbar?.items, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        titleView = storyboard.instantiateViewControllerWithIdentifier("TitleView") as? TitleView
        titleView?.matchLabel?.text = ""
        titleView?.view.frame = CGRect(x: 0, y: 5.5, width: 150, height: 33)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.navigationItem.title = ""
        titleView?.view.center.x = (self.navigationController?.navigationBar.center.x)!
        self.navigationController?.toolbar.barTintColor = UIColor.orangeColor()
        print(titleView?.view.center)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.changeToolbars(self.editing, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
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
        self.changeToolbars(editing, animated: animated)
    }
    
    func changeToolbars(editing: Bool, animated: Bool) {
        self.setToolbarItems((editing ? editToolbar?.items : mainToolbar?.items), animated: animated)
        titleView?.matchLabel?.text = (editing) ? "Edit List" : "Scouting List"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Matches"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MatchStore.sharedStore.allMatches?.count)!
    }
}