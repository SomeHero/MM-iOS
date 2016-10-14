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
public class Plan: Mappable {
    public var id: String!
    public var planId: String!
    public var name: String!
    public var amount: Double!
    //public var currency: String!
    public var interval: String!
    public var intervalCount: Int!
    public var statementDescriptor: String?
    public var statementDescription: String?
    public var trialPeriodDays: Int = 0
    //public var planCreated: NSDate!
    //public var createdAt: NSDate!
    //public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        planId <- map["reference_id"]
        name <- map["name"]
        amount <- map["amount"]
        //currency <- map["currency"]
        interval <- map["interval"]
        intervalCount <- map["interval_count"]
        statementDescriptor <- map["statement_descriptor"]
        statementDescription <- map["statement_description"]
        trialPeriodDays <- map["trial_period_days"]
        //planCreated <- (map["created"], ISO8601ExtendedDateTransform())
        //updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}