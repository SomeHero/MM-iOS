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
}