//
//  ScoutDataViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 1/5/16.
//  Copyright © 2016 dhanwada. All rights reserved.
//

import UIKit

class ScoutDataViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentMatch:Match = Match()
    var container:ScoutContainerViewController? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
