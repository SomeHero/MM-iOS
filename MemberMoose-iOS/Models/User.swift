//
//  User.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class User: Mappable {
    public var id: String!
    public var companyName: String!
    public var emailAddress: String!
    public var avatar: Dictionary<String, String>? = [:]
    public var plans: [Plan] = []
    public var subscriptions: [Subscription] =  []
    public var paymentCards: [PaymentCard] = []
    public var paymentHistory: [Transaction] = []
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public init(userId: String, companyName: String, emailAddress: String) {
        self.id = userId
        self.companyName = companyName
        self.emailAddress = emailAddress
    }
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        companyName <- map["company_name"]
        emailAddress <- map["email_address"]
        avatar <- map["avatar"]
        plans <- map["plans"]
        subscriptions <- map["subscriptions"]
        paymentCards <- map["payment_cards"]
        paymentHistory <- map["transactions"]
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
