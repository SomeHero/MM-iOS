//
//  File.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 11/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Message: Mappable {
    var id: String!
    var sender: User!
    var recipient: User!
    var content: String!
    var createdAt: Date!
    var updatedAt: Date?
    
    public required init?(map: Map){
        mapping(map: map)
    }
    open func mapping(map: Map) {
        id <- map["_id"]
        sender <- map["sender"]
        recipient <- map["recipient"]
        content <- map["content"]
        createdAt <- (map["createdAt"], ISO8601ExtendedDateTransform())
        updatedAt <- (map["updatedAt"], ISO8601ExtendedDateTransform())
    }
}
