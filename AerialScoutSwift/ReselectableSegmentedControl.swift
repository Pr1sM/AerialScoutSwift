//
//  ReselectableSegmentedControl.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 1/12/16.
//  Copyright © 2016 dhanwada. All rights reserved.
//

import UIKit

class ReselectableSegmentedControl: UISegmentedControl {
    @IBInspectable var allowReselection:Bool = true
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let lastSelectedIndex = self.selectedSegmentIndex
        super.touchesEnded(touches, withEvent: event)
        if allowReselection && lastSelectedIndex == self.selectedSegmentIndex {
            if let touch:UITouch = touches.first {
                let touchLocation = touch.locationInView(self)
                if CGRectContainsPoint(bounds, touchLocation) {
                    self.sendActionsForControlEvents(.ValueChanged)
                }
            }
        }
    }
}
