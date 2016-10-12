//
//  Member.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Member: Mappable {
    //public var id: String!
    public var memberId: String!
    public var name: String?
    public var emailAddress: String!
    public var memberCreated: NSDate!
    public var subscriptions: [Subscription] = []
    public var paymentCards: [PaymentCard] = []
    public var paymentHistory: [Transaction] = []
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        memberId <- map["id"]
        name <- map["name"]
        emailAddress <- map["email"]
        memberCreated <- (map["created"], ISO8601ExtendedDateTransform())
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
