//
//  Member.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Member: Mappable {
    open var id: String!
    open var memberId: String!
    open var first_name: String?
    open var last_name: String?
    open var emailAddress: String!
    open var memberCreated: Date!
    open var subscriptions: [Subscription] = []
    open var paymentCards: [PaymentCard] = []
    open var createdAt: Date!
    open var updatedAt: Date?
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["_id"]
        memberId <- map["reference_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        emailAddress <- map["email_address"]
        memberCreated <- (map["member_since"], ISO8601ExtendedDateTransform())
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
