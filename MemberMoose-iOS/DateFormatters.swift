//
//  Formatters.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import Foundation

let kMillisecondsTimeInterval: Double = 1000

struct DateFormatters {
    
    static func epochFrom(date: Date) -> Double {
        return date.timeIntervalSince1970 * kMillisecondsTimeInterval
    }
    static func offsetEpochFrom(date: Date) -> Double {
        let gmtOffset:Double = { return Double(NSTimeZone.default.secondsFromGMT())}()
        return (date.timeIntervalSince1970+gmtOffset)*kMillisecondsTimeInterval
    }
    
    static func epochStringFrom(date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        let epoch = DateFormatters.epochFrom(date: date)
        
        return String(format: "%.0f", epoch)
    }
    
    static func dateFrom(epoch: Double) -> Date {
        return Date(timeIntervalSince1970: (epoch/kMillisecondsTimeInterval))
    }
    
    static func dateFromEpochWithGMTOffset(epoch:Double) -> Date {
        let gmtOffset:Double = { return Double(NSTimeZone.default.secondsFromGMT())}()
        let secondsSince1970 = epoch/kMillisecondsTimeInterval - gmtOffset
        return Date(timeIntervalSince1970: secondsSince1970)
    }
    
    static func dateFormatterForMonthDay() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("LLL d")
    }
    
    static func dateFormatterForMonthDayYear() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("M/d/yyyy")
    }
    
    static func dateFormatterForActivityDateAndTime () -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("EE M/d/yy    h:mm a")
    }
    
    static func dateFormatterForTwoDigitYear() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("MM/dd/yy")
    }
    
    static func dateFormatterForUTCDate() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("yyyy-MM-dd HH:mm:ss zzz")
    }
    
    static func dateFormatterForMonthDayYearAbbr() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("LLL d, yyyy")
    }
    
    static func dateFormatterForYear() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("yyyy")
    }
    
    static func dateFormatterForDashDate() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("yyyy-MM-dd")
    }
    
    static let smallDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        
        return formatter
    }()
    
    static func dateFormatterForLongStyle() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("LLLL d, yyyy")
    }
    
    static func dateFormatterForMonthYear() -> DateFormatter {
        return DateFormatters.dateFormatterWithFormat("MMMM yyyy")
    }
    
    static let timeStampDateFormatter: DateFormatter = {
        return DateFormatters.dateFormatterWithFormat("MMM d, YYYY 'at' h:mm a")
    }()
    
    fileprivate static func dateFormatterWithFormat(_ format: String) -> DateFormatter {
        let threadDict = Thread.current.threadDictionary
        
        let formatter: DateFormatter
        
        if let _formatter = threadDict[format] as? DateFormatter {
            formatter = _formatter
        } else {
            formatter = DateFormatter()
            formatter.dateFormat = format
            
            threadDict[format] = formatter
        }
        
        return formatter
    }
}
