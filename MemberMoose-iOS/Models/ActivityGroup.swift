//
//  ActivityGroup.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 1/5/17.
//  Copyright © 2017 James Rhodes. All rights reserved.
//

import Foundation
import ObjectMapper

open class ActivityGroup: Mappable {
    var groupDate: Date!
    var activities: [Activity] = []
    
    public required init?(map: Map){
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        groupDate <- map["date_group"]
        activities <- map["activities"]
    }
}
