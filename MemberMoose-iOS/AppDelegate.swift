//
//  AppDelegate.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/4/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var swRevealViewController: SWRevealViewController?
    
    override init() {
        ApiManager.sharedInstance.apiBaseUrl = kApiBaseUrl

        super.init()
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()
        
        UITheme.configureTheme()
        
        if let token = SessionManager.sharedInstance.getToken(), user = SessionManager.getPersistedUser() {
            SessionManager.sharedUser = user
            SessionManager.persistUser()
            
            ApiManager.sharedInstance.token = token
            
            let viewController = ProfileViewController(user: user, profileType: .bull)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBarHidden = true
            
            let menuViewController = MenuViewController()
            
            let revealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
            
            swRevealViewController = revealViewController
            
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            window?.rootViewController = swRevealViewController
            window?.makeKeyAndVisible()
        } else {
            let viewController = JoinViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBarHidden = true
            
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handleOpenURL(url)
        }
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.i
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }
        
        if (url.host == "membermoose-node.herokuapp.com") {
            OAuthSwift.handleOpenURL(url)
            
            return true
        }
        
        return false
    }

}

