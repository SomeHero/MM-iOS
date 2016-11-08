//
//  ReferencePlan.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/31/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class ReferencePlan: Mappable {
    open var id: String!
    open var referenceId: String!
    open var planName: String!

    public required init?(map: Map){
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["id"]
        referenceId <- map["reference_id"]
        planName <- map["plan_name"]
    }
}
