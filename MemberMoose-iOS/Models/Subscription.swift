//
//  Subscription.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Subscription: Mappable {
    public var id: String!
    public var plan: Plan!
    public var status: String!
    public var subscriptionDate: NSDate!
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        plan <- map["plan"]
        status <- map["status"]
        subscriptionDate <- (map["subscription_date"], ISO8601ExtendedDateTransform())
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
