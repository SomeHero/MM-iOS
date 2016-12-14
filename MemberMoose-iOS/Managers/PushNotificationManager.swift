//
//  PushNotificationManager.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import UserNotifications

class PushNotificationManager {
    static func registerForPushNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
        
    }
}
