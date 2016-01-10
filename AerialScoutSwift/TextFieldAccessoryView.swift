//
//  TextFieldAccessoryView.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 1/9/16.
//  Copyright © 2016 dhanwada. All rights reserved.
//

import UIKit

class TextFieldAccessoryView: UITextField {
    
    private var inputToolbar:UIToolbar? = nil
    
    @IBOutlet var nextField:UIResponder?
    @IBOutlet var prevField:UIResponder?

    override var inputAccessoryView:UIView? {
        get {
            if(inputToolbar == nil) {
                inputToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
                let navUp = UIButton(type: .Custom)
                let navDown = UIButton(type: .Custom)
                navUp.frame = CGRectMake(0, 0, 44, 44)
                navUp.addTarget(self, action: "goToPrevResponder:", forControlEvents: .TouchUpInside)
                navUp.showsTouchWhenHighlighted = true
                navUp.setImage(UIImage(imageLiteral: "KeyboardNavUp"), forState: .Normal)
                navDown.frame = navUp.frame
                navDown.addTarget(self, action: "goToNextResponder:", forControlEvents: .TouchUpInside)
                navDown.showsTouchWhenHighlighted = true
                navDown.setImage(UIImage(imageLiteral: "KeyboardNavDown"), forState: .Normal)
                
                let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "callToEndEditing:")
                
                inputToolbar?.items = [
                    UIBarButtonItem(customView: navUp),
                    UIBarButtonItem(customView: navDown),
                    flexSpace,
                    done
                ]
                
                navUp.enabled = (prevField != nil)
                navDown.enabled = (nextField != nil)
            }
            return inputToolbar
        }
        
        set {}
    }
    
    func callToEndEditing(sender:AnyObject) {
        self.delegate?.textFieldShouldReturn!(self)
    }
    
    func goToNextResponder(sender:AnyObject) {
        if nextField != nil {
            nextField!.becomeFirstResponder()
        }
    }
    
    func goToPrevResponder(sender:AnyObject) {
        if prevField != nil {
            prevField!.becomeFirstResponder()
        }
    }
}
