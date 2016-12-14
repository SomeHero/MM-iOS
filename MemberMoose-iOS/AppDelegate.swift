//
//  AppDelegate.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/4/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController
import SwiftyOAuth
import Stripe
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var swRevealViewController: SWRevealViewController?
    
    let stripe = Provider.stripe(
        clientID:     kStripeConnectClientId,
        clientSecret: kStripeSecretKey,
        redirectURL:  kStripeOAuthRedirectUrl
    )
    override init() {
        ApiManager.sharedInstance.apiBaseUrl = kApiBaseUrl

        super.init()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        
        UITheme.configureTheme()
        
        if let token = SessionManager.sharedInstance.getToken(), let user = SessionManager.getPersistedUser() {
            SessionManager.sharedUser = user
            SessionManager.persistUser()
            Stripe.setDefaultPublishableKey(kStripePublishableKey)
            
            ApiManager.sharedInstance.token = token
            
            if let refreshToken = SessionManager.sharedInstance.getRefreshToken() {
                ApiManager.sharedInstance.refreshToken = refreshToken
            }
            
            let viewController = ProfileViewController(user: user, profileType: .bull)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.isNavigationBarHidden = true
            
            let menuViewController = MenuViewController()
            
            let revealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
            
            swRevealViewController = revealViewController
            
            window = UIWindow(frame: UIScreen.main.bounds)
            
            window?.rootViewController = swRevealViewController
            window?.makeKeyAndVisible()
        } else {
            let viewController = JoinViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.isNavigationBarHidden = true
            
            window = UIWindow(frame: UIScreen.main.bounds)
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if (url.host == "oauth-callback") {
            stripe.handleURL(url, options: options)
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.i
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let uuid = UUID().uuidString
        print(deviceTokenString)
        
        let registerDevice = RegisterDevice(user: user, token: deviceTokenString, deviceIdentifier: uuid, deviceType: "iPhone")
        
        ApiManager.sharedInstance.registerDevice(registerDevice, success: { (user) in
            print("register device success")
        }, failure: { (error) in
            print("failed to register device \(error)")
        })
 
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Swift.Error) {
        print("i am not available in simulator \(error)")
    }
//    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
//        guard let url = userActivity.webpageURL else {
//            return false
//        }
//        
//        if (url.host == "membermoose-node.herokuapp.com") {
//            Provider.Stripe.handleOpenURL(url, options: nil)
//            
//            return true
//        }
//        
//        return false
//    }

}

