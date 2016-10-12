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
    public var firstName: String!
    public var lastName: String!
    public var emailAddress: String!
    public var subscriptions: [Subscription] =  []
    public var paymentCards: [PaymentCard] = []
    public var paymentHistory: [Transaction] = []
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        emailAddress <- map["email_address"]
        subscriptions <- map["subscriptions"]
        paymentCards <- map["payment_cards"]
        paymentHistory <- map["transactions"]
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
