//
//  Activity.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 12/13/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Activity: Mappable {
    var id: String!
    var activityType: String!
    var messageCalf: String!
    var messageBull: String!
    var source: String!
    var plan: Plan?
    var calf: User?
    var bull: User!
    var receivedAt: Date!
    var createdAt: Date!
    var updatedAt: Date?
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["_id"]
        activityType <- map["activity_type"]
        messageCalf <- map["message_calf"]
        messageBull <- map["message_bull"]
        source <- map["source"]
        plan <- map["plan"]
        calf <- map["calf"]
        bull <- map["bull"]
        receivedAt <- (map["received_at"], ISO8601ExtendedDateTransform())
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
