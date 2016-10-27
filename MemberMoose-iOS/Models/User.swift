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
    public var firstName: String?
    public var lastName: String?
    //public var companyName: String!
    public var emailAddress: String!
    public var avatar: Dictionary<String, String>? = [:]
    public var account: Account?
    public var plans: [Plan] = []
    public var subscriptions: [Subscription] =  []
    public var memberships: [Membership] = []
    public var paymentCards: [PaymentCard] = []
    var charges: [Charge] = []
    public var memberCount: Int = 0
    public var createdAt: NSDate!
    public var updatedAt: NSDate?
    
    public init(userDefaults: NSUserDefaults) {
        self.id = userDefaults.stringForKey("id")
        self.firstName = userDefaults.stringForKey("firstName")
        self.lastName = userDefaults.stringForKey("lastName")
        self.emailAddress = userDefaults.stringForKey("email_address")!
        let avatar = userDefaults.valueForKey("avatar")
        if let avatar = avatar as? Dictionary<String, String> {
            self.avatar = avatar
        }
        self.account = Account(userDefaults: userDefaults)
        self.memberCount = userDefaults.integerForKey("member_count")
    }
    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        //companyName <- map["company_name"]
        emailAddress <- map["email_address"]
        avatar <- map["avatar"]
        account <- map["account"]
        plans <- map["plans"]
        subscriptions <- map["subscriptions"]
        memberships <- map["memberships"]
        paymentCards <- map["payment_cards"]
        charges <- map["charges"]
        memberCount <- map["member_count"]
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
    func persistToUserDefaults(userDefaults: NSUserDefaults) {
        userDefaults.setValuesForKeysWithDictionary([
            "id": id,
            "email_address": emailAddress,
            "member_count": memberCount
            ])
        if let avatar = self.avatar {
            userDefaults.setValue(avatar, forKey: "avatar")
        }
        if let firstName = firstName {
            userDefaults.setValue(firstName, forKey: "first_name")
        }
        if let lastName = lastName {
            userDefaults.setValue(lastName, forKey: "last_name")
        }
        if let account = account {
            account.persistToUserDefaults(userDefaults)
        }
        
        userDefaults.synchronize()
    }
}
