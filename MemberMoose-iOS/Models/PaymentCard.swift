//
//  PaymentCard.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class PaymentCard: Mappable {
    open var id: String!
    open var nameOnCard: String?
    open var brand: String!
    open var cardLastFour: String!
    open var expirationMonth: Int!
    open var expirationYear: Int!
    open var createdAt: Date!
    open var updatedAt: Date?
    
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["id"]
        brand <- map["brand"]
        nameOnCard <- map["name"]
        cardLastFour <- map["last4"]
        expirationMonth <- map["exp_month"]
        expirationYear <- map["exp_year"]
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
