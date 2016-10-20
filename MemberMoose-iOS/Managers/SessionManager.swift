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
        
        userDefaults.setValuesForKeysWithDictionary([
            "id": user.id!,
            "company_name": user.companyName,
            "email_address": user.emailAddress,
            ])
        if let avatar = user.avatar {
            userDefaults.setValue(avatar, forKey: "avatar")
        }
        if let firstName = user.firstName {
            userDefaults.setValue(firstName, forKey: "first_name")
        }
        if let lastName = user.lastName {
            userDefaults.setValue(lastName, forKey: "last_name")
        }
        
        userDefaults.synchronize()
    }
    static func getPersistedUser() -> User? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        guard let id = userDefaults.stringForKey("id") else {
            return nil
        }
        let companyName = userDefaults.stringForKey("company_name")!
        let emailAddress = userDefaults.stringForKey("email_address")!
        let avatar = userDefaults.valueForKey("avatar")
        let firstName = userDefaults.stringForKey("first_name")
        let lastName = userDefaults.stringForKey("last_name")
        
        let user = User(userId: id, companyName: companyName, emailAddress: emailAddress, firstName: firstName, lastName: lastName)
        
        if let avatar = avatar as? Dictionary<String, String> {
            user.avatar = avatar
        }
        
        return user
    }
}
