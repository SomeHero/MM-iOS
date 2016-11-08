//
//  Subscription.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Subscription: Mappable {
    open var id: String!
    open var plan: Plan!
    open var status: String!
    open var subscriptionDate: Date!
    open var createdAt: Date!
    open var updatedAt: Date?
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["_id"]
        plan <- map["plan"]
        status <- map["status"]
        subscriptionDate <- (map["subscription_date"], ISO8601ExtendedDateTransform())
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
