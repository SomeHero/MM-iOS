//
//  Plan.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Printable {
    var description: String { get }
}
//day, week, month or year
enum RecurringInterval: Int, Printable {
    case day = 0
    case week = 1
    case month = 2
    case year = 3
    
    var description: String {
        switch self {
        case .day: return "day"
        case .week   : return "week"
        case .month  : return "month"
        case .year : return "year"
        }
    }
}

enum CurrencyCode: String {
    case USD = "USD"
}
open class Plan: Mappable {
    var id: String?
    var planId: String?
    var name: String?
    var avatar: Dictionary<String, String>? = [:]
    var description: String?
    var features: [String] = []
    var oneTimeAmount: Double?
    var amount: Double?
    //public var currency: String!
    var interval: RecurringInterval?
    var intervalCount: Int = 00
    var statementDescriptor: String?
    var statementDescription: String?
    var trialPeriodDays: Int = 0
    var termsOfService: String?
    //public var planCreated: NSDate!
    var memberCount: Int = 0
    var createdAt: Date?
    var updatedAt: Date?
    
    init() {
        
    }
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["_id"]
        planId <- map["reference_id"]
        name <- map["name"]
        avatar <- map["avatar"]
        description <- map["description"]
        features <- map["features"]
        oneTimeAmount <- map["one_time_amount"]
        amount <- map["amount"]
        //currency <- map["currency"]
        interval <- (map["interval"], EnumTransform<RecurringInterval>())
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
