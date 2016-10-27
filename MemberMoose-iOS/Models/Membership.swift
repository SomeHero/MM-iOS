//
//  Membership.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Membership: Mappable {
    public var id: String!
    public var reference_id: String!
    public var company_name: String!
    public var subscription: Subscription?
    public var planNames: [String] = []
    public var createdAt: NSDate!
    public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        reference_id <- map["reference_id"]
        company_name <- map["company_name"]
        subscription <- map["subscription"]
        planNames <- map["plan_names"]
        //subscriptionDate <- (map["subscription_date"], ISO8601ExtendedDateTransform())
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
