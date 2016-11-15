//
//  User.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class User: Mappable {
    open var id: String!
    open var firstName: String?
    open var lastName: String?
    //public var companyName: String!
    open var emailAddress: String!
    open var avatar: Dictionary<String, String>? = [:]
    open var account: Account?
    open var plans: [Plan] = []
    open var subscriptions: [Subscription] =  []
    open var memberships: [Membership] = []
    open var paymentCards: [PaymentCard] = []
    var charges: [Charge] = []
    open var memberCount: Int = 0
    var gravatarUrl: String?
    open var createdAt: Date!
    open var updatedAt: Date?
    
    public init(userDefaults: UserDefaults) {
        self.id = userDefaults.string(forKey: "id")
        self.firstName = userDefaults.string(forKey: "firstName")
        self.lastName = userDefaults.string(forKey: "lastName")
        self.emailAddress = userDefaults.string(forKey: "email_address")!
        let avatar = userDefaults.value(forKey: "avatar")
        if let avatar = avatar as? Dictionary<String, String> {
            self.avatar = avatar
        }
        self.account = Account(userDefaults: userDefaults)
        self.memberCount = userDefaults.integer(forKey: "member_count")
    }
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
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
        gravatarUrl <- map["gravatar_url"]
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
    func persistToUserDefaults(_ userDefaults: UserDefaults) {
        userDefaults.setValuesForKeys([
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
