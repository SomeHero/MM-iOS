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
    static var sharedUser: User?
    
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
    static func persistUser() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        user.persistToUserDefaults(userDefaults)
    }
    static func getPersistedUser() -> User? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let user = User(userDefaults: userDefaults)
        
        return user
    }
}
