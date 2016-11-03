//
//  ReferencePlan.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/31/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

public class ReferencePlan: Mappable {
    public var id: String!
    public var referenceId: String!
    public var planName: String!

    public required init?(_ map: Map){
        mapping(map)
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        referenceId <- map["reference_id"]
        planName <- map["plan_name"]
    }
}
