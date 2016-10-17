//
//  Transaction.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Transaction: Mappable {
    public var id: String!
    public var amount: NSDecimalNumber!
    public var status: String!
    public var transactionDate: NSDate!
    public var transactionDescription: String!
    public var cardDescription: String!
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        amount <- map["amount"]
        status <- map["status"]
        transactionDate <- (map["transaction_date"], ISO8601ExtendedDateTransform())
        transactionDescription <- map["transaction_description"]
        cardDescription <- map["card_description"]
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}