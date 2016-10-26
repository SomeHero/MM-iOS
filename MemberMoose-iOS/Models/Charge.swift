//
//  Charge.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Charge: Mappable {
    public var id: String!
    public var referenceId: String!
    public var amount: Double!
    public var amountRefunded: Double!
    public var balanceTransaction: String!
    public var captured: Bool!
    public var chargeCreated: NSDate!
    var currency: String!
    var description: String!
    var destination: String?
    var dispute: String?
    var failureCode: String?
    var failureMessage: String?
    var invoice: String?
    var paid: Bool!
    var refunded: Bool!
    var shipping: String?
    var sourceTransfer: String?
    var statementDescriptor: String?
    var status: String!
    var cardInfo: String!
    public var createdAt: NSDate!
    public var updatedAt: NSDate?
    
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        referenceId <- map["reference_id"]
        amount <- map["amount"]
        amountRefunded <- map["amount_refunded"]
        balanceTransaction <- map["balance_transaction"]
        captured <- map["captured"]
        chargeCreated <- (map["charge_created"], ISO8601ExtendedDateTransform())
        currency <- map["currency"]
        description <- map["description"]
        destination <- map["destination"]
        dispute <- map["dispute"]
        failureCode <- map["failure_code"]
        failureMessage <- map["failure_message"]
        invoice <- map["invoice"]
        paid <- map["paid"]
        refunded <- map["refunded"]
        shipping <- map["shipping"]
        sourceTransfer <- map["source_transfer"]
        statementDescriptor <- map["statement_descriptor"]
        status <- map["status"]
        cardInfo <- map["card_info"]
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}