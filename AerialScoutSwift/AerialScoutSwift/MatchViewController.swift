//
//  MatchViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/19/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class MatchViewController : UITableViewController {
    
    @IBOutlet var editToolbar : UIToolbar?;
    @IBOutlet var mainToolbar : UIToolbar?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBarHidden = false
        self.setToolbarItems(mainToolbar?.items, animated: true)
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
    }
}