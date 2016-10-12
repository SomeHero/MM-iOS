//
//  UITheme.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SVProgressHUD

struct UITheme {
    static func configureTheme() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.window?.tintColor = UIColor.flatOrangeColor()
        }
        UITabBar.appearance().translucent = false
        UITabBar.appearance().backgroundColor = UIColorTheme.Primary
        //UITabBar.appearance().tintColor = .blackColor()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColorTheme.NavBarForegroundColor
        UINavigationBar.appearance().translucent = false
        
        let titleAttributes = [
            NSFontAttributeName: UIFontTheme.Bold(.Large),
            NSForegroundColorAttributeName: UIColor(hexString: "333333")
        ]
        
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        
        let barAttributes = [NSFontAttributeName : UIFontTheme.Regular(), NSForegroundColorAttributeName : UIColorTheme.NavBarForegroundColor]
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).tintColor = UIColorTheme.NavBarForegroundColor
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).setTitleTextAttributes(barAttributes, forState: .Normal)
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        SVProgressHUD.setForegroundColor(UIColorTheme.Primary)
        
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).defaultTextAttributes = [NSFontAttributeName : UIFontTheme.Regular(.Small), NSForegroundColorAttributeName : UIColor.flatWhiteColor()]
        
        let searchBarAttributes = [NSFontAttributeName : UIFontTheme.Regular(.Small), NSForegroundColorAttributeName : UIColor.flatWhiteColor()]
        let searchBarTitle = "Search Markets"
        let placeholder = NSAttributedString(string: searchBarTitle, attributes: searchBarAttributes)
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).attributedPlaceholder = placeholder
        
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.flatWhiteColor()
    }
}
