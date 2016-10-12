//
//  SessionManager.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/12/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import SVProgressHUD

class SessionManager: NSObject {
    static let sharedInstance = SessionManager()
    
    private override init() {}
    
    func setToken(token: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setValue(token, forKey: "token")
        
        userDefaults.synchronize()
    }
    func getToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefaults.stringForKey("token")
    }
    func logout() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("token")
        
        userDefaults.synchronize()
    }
    func clearToken() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("token")
        
        userDefaults.synchronize()
    }
}
