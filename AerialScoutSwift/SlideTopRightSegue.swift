//
//  SlideTopRightSegue.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 1/8/16.
//  Copyright © 2016 dhanwada. All rights reserved.
//

import UIKit

class SlideTopRightSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVCView = self.sourceViewController.navigationController!.view as UIView
        let destVCView = self.destinationViewController.view as UIView
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        destVCView.frame = CGRectMake(screenBounds.width, -screenBounds.height, screenBounds.width, screenBounds.height)
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(destVCView, aboveSubview: sourceVCView)
        
        let duration = 0.6
        let delay = 0.0
        let damping:CGFloat = 0.7
        let initialVelocity:CGFloat = 0.0
        let options = UIViewAnimationOptions.CurveEaseOut
        let animations = {() in
            destVCView.frame = sourceVCView.frame
        }
        let completion = {(finished:Bool) -> Void in
            self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
        }
        
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: options, animations: animations, completion: completion)
    }
}
