//
//  Account.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Account: Mappable {
    public var id: String!
    public var companyName: String!
    public var avatar: Dictionary<String, String>? = [:]
    public var subdomain: String!
    public var status: String!
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public init(userDefaults: NSUserDefaults) {
        self.id = userDefaults.stringForKey("id")
        self.companyName = userDefaults.stringForKey("companyName")
        let avatar = userDefaults.valueForKey("avatar")
        if let avatar = avatar as? Dictionary<String, String> {
            self.avatar = avatar
        }
        self.subdomain = userDefaults.stringForKey("subdomain")
        self.status = userDefaults.stringForKey("status")
    }
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        companyName <- map["company_name"]
        avatar <- map["avatar"]
        subdomain <- map["subdomain"]
        status <- map["status"]
        //createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
    func persistToUserDefaults(userDefaults: NSUserDefaults) {
        userDefaults.setValuesForKeysWithDictionary([
            "id": id,
            "companyName": companyName,
            "subdomain": subdomain,
            "status": status
            ])
        if let avatar = self.avatar {
            userDefaults.setValue(avatar, forKey: "avatar")
        }
        
        userDefaults.synchronize()
    }
}