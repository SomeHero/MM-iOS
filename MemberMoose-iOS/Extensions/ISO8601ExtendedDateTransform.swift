//
//  ISODateTransfrom.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//


import Foundation
import ObjectMapper

class ISO8601ExtendedDateTransform: DateFormatterTransform {
    init() {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        super.init(dateFormatter: formatter)
    }
    
}