//
//  KeyboardDecorator.swift
//  ShopperApp
//
//  Created by James Rhodes on 8/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import FontAwesome_swift

@objc protocol InputNavigationDelegate: PickerToolbarDelegate {
    func gotoPreviousInput()
    func gotoNextInput()
    
    func toggleKeyboardNavButtonsEnabled(toolBar: UIToolbar)
}

extension InputNavigationDelegate {
    func toggleKeyboardNavButtonsEnabled(toolBar: UIToolbar) { }
}

@objc protocol PickerToolbarDelegate: class {
    func dismissKeyboard()
    
    func keyboardDidAppear(notification: NSNotification)
    func keyboardDidHide(notification: NSNotification)
}

class KeyboardDecorator {
    static let fixedToolbarSpacing: CGFloat = 25
    static let previousIndex = 0
    static let nextIndex = 2
    static let keyboardToolbarHeight: CGFloat = 44

    
    class func applyStandardStyling(toolbar: UIToolbar) {
        toolbar.barTintColor = UIColor.lightGrayColor()
        toolbar.tintColor = UIColorTheme.Primary
        toolbar.opaque = true
        toolbar.translucent = false
    }
    
    class func getInputToolbarWithDelegate(delegate: InputNavigationDelegate) -> UIToolbar {
        let previous = keyboardButtonWithIcon(delegate, icon: FontAwesome.ChevronLeft, action: #selector(InputNavigationDelegate.gotoPreviousInput))
        let next = keyboardButtonWithIcon(delegate, icon: FontAwesome.ChevronRight, action: #selector(InputNavigationDelegate.gotoNextInput))
        
        let attributes = [NSFontAttributeName : UIFontTheme.Regular()]
        let done = UIBarButtonItem(title: "Done", style: .Done, target: delegate, action: #selector(PickerToolbarDelegate.dismissKeyboard))
        done.setTitleTextAttributes(attributes, forState: .Normal)
        
        let fixed = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixed.width = fixedToolbarSpacing
        let middle = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, KeyboardDecorator.keyboardToolbarHeight))
        applyStandardStyling(toolBar)
        
        toolBar.setItems([previous, fixed, next, middle, done], animated: true)
        
        return toolBar
    }
    
    class func getStandardPickerToolbar(delegate: PickerToolbarDelegate) -> UIToolbar {
        let attributes = [NSFontAttributeName : UIFontTheme.Regular(.Large)]
        let done = UIBarButtonItem(title: "Done", style: .Done, target: delegate, action: #selector(PickerToolbarDelegate.dismissKeyboard))
        done.setTitleTextAttributes(attributes, forState: .Normal)
        
        let middle = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, keyboardToolbarHeight))
        applyStandardStyling(toolBar)
        
        toolBar.setItems([middle, done], animated: true)
        
        return toolBar
    }
    
    class func keyboardButtonWithIcon(delegate: InputNavigationDelegate, icon: FontAwesome, action: Selector) -> UIBarButtonItem {
        let attributes = [NSFontAttributeName : UIFontTheme.Icon(.Default)]
        let iconText = String.fontAwesomeIconWithName(icon)
        let button = UIBarButtonItem(title: iconText, style: .Plain, target: delegate, action: action)
        button.setTitleTextAttributes(attributes, forState: .Normal)
        
        return button
    }
}
