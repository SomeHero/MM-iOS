    //
//  Account.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/21/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Account: Mappable {
    open var id: String!
    open var companyName: String!
    open var avatar: Dictionary<String, String>? = [:]
    open var subdomain: String!
    open var status: String!
    open var referencePlans: [ReferencePlan]!
    open var createdAt: Date!
    open var updatedAt: Date?
    
    public init(userDefaults: UserDefaults) {
        self.id = userDefaults.string(forKey: "id")
        self.companyName = userDefaults.string(forKey: "companyName")
        let avatar = userDefaults.value(forKey: "avatar")
        if let avatar = avatar as? Dictionary<String, String> {
            self.avatar = avatar
        }
        self.subdomain = userDefaults.string(forKey: "subdomain")
        self.status = userDefaults.string(forKey: "status")
        self.referencePlans = []
    }
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["_id"]
        companyName <- map["company_name"]
        avatar <- map["avatar"]
        subdomain <- map["subdomain"]
        status <- map["status"]
        referencePlans <- map["reference_plans"]
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
    func persistToUserDefaults(_ userDefaults: UserDefaults) {
        userDefaults.setValuesForKeys([
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
