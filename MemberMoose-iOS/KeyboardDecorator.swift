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
    
    func toggleKeyboardNavButtonsEnabled(_ toolBar: UIToolbar)
}

extension InputNavigationDelegate {
    func toggleKeyboardNavButtonsEnabled(_ toolBar: UIToolbar) { }
}

@objc protocol PickerToolbarDelegate: class {
    func dismissKeyboard()
    
    func keyboardDidAppear(_ notification: Notification)
    func keyboardDidHide(_ notification: Notification)
}

class KeyboardDecorator {
    static let fixedToolbarSpacing: CGFloat = 25
    static let previousIndex = 0
    static let nextIndex = 2
    static let keyboardToolbarHeight: CGFloat = 44

    
    class func applyStandardStyling(_ toolbar: UIToolbar) {
        toolbar.barTintColor = UIColor.lightGray
        toolbar.tintColor = UIColorTheme.Primary
        toolbar.isOpaque = true
        toolbar.isTranslucent = false
    }
    
    class func getInputToolbarWithDelegate(_ delegate: InputNavigationDelegate) -> UIToolbar {
        let previous = keyboardButtonWithIcon(delegate, icon: FontAwesome.chevronLeft, action: #selector(InputNavigationDelegate.gotoPreviousInput))
        let next = keyboardButtonWithIcon(delegate, icon: FontAwesome.chevronRight, action: #selector(InputNavigationDelegate.gotoNextInput))
        
        let attributes = [NSFontAttributeName : UIFontTheme.Regular()]
        let done = UIBarButtonItem(title: "Done", style: .done, target: delegate, action: #selector(PickerToolbarDelegate.dismissKeyboard))
        done.setTitleTextAttributes(attributes, for: UIControlState())
        
        let fixed = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = fixedToolbarSpacing
        let middle = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width, height: KeyboardDecorator.keyboardToolbarHeight))
        applyStandardStyling(toolBar)
        
        toolBar.setItems([previous, fixed, next, middle, done], animated: true)
        
        return toolBar
    }
    
    class func getStandardPickerToolbar(_ delegate: PickerToolbarDelegate) -> UIToolbar {
        let attributes = [NSFontAttributeName : UIFontTheme.Regular(.large)]
        let done = UIBarButtonItem(title: "Done", style: .done, target: delegate, action: #selector(PickerToolbarDelegate.dismissKeyboard))
        done.setTitleTextAttributes(attributes, for: UIControlState())
        
        let middle = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width, height: keyboardToolbarHeight))
        applyStandardStyling(toolBar)
        
        toolBar.setItems([middle, done], animated: true)
        
        return toolBar
    }
    
    class func keyboardButtonWithIcon(_ delegate: InputNavigationDelegate, icon: FontAwesome, action: Selector) -> UIBarButtonItem {
        let attributes = [NSFontAttributeName : UIFontTheme.Icon(.default)]
        let iconText = String.fontAwesomeIcon(name: icon)
        let button = UIBarButtonItem(title: iconText, style: .plain, target: delegate, action: action)
        button.setTitleTextAttributes(attributes, for: .normal)
        
        return button
    }
}
