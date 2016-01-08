//
//  SlideTopRightUnwindSegue.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 1/8/16.
//  Copyright © 2016 dhanwada. All rights reserved.
//

import UIKit

class SlideTopRightUnwindSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVCView = self.sourceViewController.navigationController!.view as UIView
        let destVCView = self.destinationViewController.navigationController!.view as UIView
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        let endFrame = CGRectMake(screenBounds.width, -screenBounds.height, screenBounds.width, screenBounds.height)
        
        let containerView = sourceVCView.superview
        containerView?.insertSubview(destVCView, belowSubview: sourceVCView)
        
        let duration = 0.8
        let delay = 0.0
        let damping:CGFloat = 0.8
        let initialVelocity:CGFloat = -10
        let options = UIViewAnimationOptions.CurveEaseIn
        let animations = {() in
            sourceVCView.frame = endFrame
        }
        let completion = {(finished:Bool) -> Void in
            self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
        
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: options, animations: animations, completion: completion)
    }
}
