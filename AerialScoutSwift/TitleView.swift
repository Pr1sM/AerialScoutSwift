//
//  TitleView.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/25/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class TitleView: UIViewController {
    
    @IBOutlet var matchLabel:UILabel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
