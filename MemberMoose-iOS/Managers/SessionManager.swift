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
    
    fileprivate override init() {}
    
    func setToken(_ token: String) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(token, forKey: "token")
        
        userDefaults.synchronize()
    }
    func getToken() -> String? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.string(forKey: "token")
    }
    func setRefreshToken(_ token: String) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(token, forKey: "refresh_token")
        
        userDefaults.synchronize()
    }
    func getRefreshToken() -> String? {
        let userDefaults = UserDefaults.standard
        
        return userDefaults.string(forKey: "refresh_token")
    }
    func logout() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "token")
        userDefaults.removeObject(forKey: "refresh_token")
        
        userDefaults.synchronize()
    }
    func clearToken() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "token")
        userDefaults.removeObject(forKey: "refresh_token")
        
        userDefaults.synchronize()
    }
    static func persistUser() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        
        let userDefaults = UserDefaults.standard
        
        user.persistToUserDefaults(userDefaults)
    }
    static func getPersistedUser() -> User? {
        let userDefaults = UserDefaults.standard
        let user = User(userDefaults: userDefaults)
        
        return user
    }
}
