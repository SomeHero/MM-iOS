//
//  Membership.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/19/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Membership: Mappable {
    open var id: String!
    open var reference_id: String!
    open var company_name: String!
    open var subscriptions: [Subscription] = []
    open var planNames: [String] = []
    open var createdAt: Date!
    open var updatedAt: Date?
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["id"]
        reference_id <- map["reference_id"]
        company_name <- map["company_name"]
        subscriptions <- map["subscriptions"]
        planNames <- map["plan_names"]
        //subscriptionDate <- (map["subscription_date"], ISO8601ExtendedDateTransform())
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
