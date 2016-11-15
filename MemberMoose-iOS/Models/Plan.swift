//
//  Plan.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

enum CurrencyCode: String {
    case USD = "USD"
}
open class Plan: Mappable {
    open var id: String!
    open var planId: String!
    open var name: String!
    var description: String?
    var oneTimeAmount: Double?
    open var amount: Double!
    //public var currency: String!
    open var interval: String!
    open var intervalCount: Int!
    open var statementDescriptor: String?
    open var statementDescription: String?
    open var trialPeriodDays: Int = 0
    var termsOfService: String?
    //public var planCreated: NSDate!
    var memberCount: Int = 0
    open var createdAt: Date!
    open var updatedAt: Date?
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["_id"]
        planId <- map["reference_id"]
        name <- map["name"]
        description <- map["description"]
        oneTimeAmount <- map["one_time_amount"]
        amount <- map["amount"]
        //currency <- map["currency"]
        interval <- map["interval"]
        intervalCount <- map["interval_count"]
        statementDescriptor <- map["statement_descriptor"]
        statementDescription <- map["statement_description"]
        trialPeriodDays <- map["trial_period_days"]
        termsOfService <- map["terms_of_service"]
        memberCount <- map["member_count"]
        //planCreated <- (map["created"], ISO8601ExtendedDateTransform())
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
