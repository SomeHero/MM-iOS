//
//  PaymentCard.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class PaymentCard: Mappable {
    public var id: String!
    public var nameOnCard: String!
    public var cardLastFour: String!
    public var expirationMonth: Int!
    public var expirationYear: Int!
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        nameOnCard <- map["name_on_card"]
        cardLastFour <- map["card_last_four"]
        expirationMonth <- map["expiration_month"]
        expirationYear <- map["expiration_year"]
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
