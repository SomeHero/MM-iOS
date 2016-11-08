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
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.tintColor = UIColor.flatOrange()
        }
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColorTheme.Primary
        //UITabBar.appearance().tintColor = .blackColor()
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColorTheme.NavBarForegroundColor
        UINavigationBar.appearance().isTranslucent = false
        
        let titleAttributes = [
            NSFontAttributeName: UIFontTheme.Bold(.large),
            NSForegroundColorAttributeName: UIColor(hexString: "333333")
        ] as [String : Any]
        
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        
        let barAttributes = [NSFontAttributeName : UIFontTheme.Regular(), NSForegroundColorAttributeName : UIColorTheme.NavBarForegroundColor]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColorTheme.NavBarForegroundColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(barAttributes, for: UIControlState())
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColorTheme.Primary)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSFontAttributeName : UIFontTheme.Regular(.small), NSForegroundColorAttributeName : UIColor.flatWhite()]
        
        let searchBarAttributes = [NSFontAttributeName : UIFontTheme.Regular(.small), NSForegroundColorAttributeName : UIColor.flatWhite()] as [String : Any]
        let searchBarTitle = "Search Markets"
        let placeholder = NSAttributedString(string: searchBarTitle, attributes: searchBarAttributes)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = placeholder
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.flatWhite()
    }
}
