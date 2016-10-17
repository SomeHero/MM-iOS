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
    
    static func epochFrom(date date: NSDate) -> Double {
        return date.timeIntervalSince1970 * kMillisecondsTimeInterval
    }
    static func offsetEpochFrom(date date: NSDate) -> Double {
        let gmtOffset:Double = { return Double(NSTimeZone.defaultTimeZone().secondsFromGMT)}()
        return (date.timeIntervalSince1970+gmtOffset)*kMillisecondsTimeInterval
    }
    
    static func epochStringFrom(date date: NSDate?) -> String {
        guard let date = date else {
            return ""
        }
        
        let epoch = DateFormatters.epochFrom(date: date)
        
        return String(format: "%.0f", epoch)
    }
    
    static func dateFrom(epoch epoch: Double) -> NSDate {
        return NSDate(timeIntervalSince1970: (epoch/kMillisecondsTimeInterval))
    }
    
    static func dateFromEpochWithGMTOffset(epoch epoch:Double) -> NSDate {
        let gmtOffset:Double = { return Double(NSTimeZone.defaultTimeZone().secondsFromGMT)}()
        let secondsSince1970 = epoch/kMillisecondsTimeInterval - gmtOffset
        return NSDate(timeIntervalSince1970: secondsSince1970)
    }
    
    static func dateFormatterForMonthDay() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("LLL d")
    }
    
    static func dateFormatterForMonthDayYear() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("M/d/yyyy")
    }
    
    static func dateFormatterForActivityDateAndTime () -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("EE M/d/yy    h:mm a")
    }
    
    static func dateFormatterForTwoDigitYear() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("MM/dd/yy")
    }
    
    static func dateFormatterForUTCDate() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("yyyy-MM-dd HH:mm:ss zzz")
    }
    
    static func dateFormatterForMonthDayYearAbbr() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("LLL d, yyyy")
    }
    
    static func dateFormatterForYear() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("yyyy")
    }
    
    static func dateFormatterForDashDate() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("yyyy-MM-dd")
    }
    
    static let smallDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter
    }()
    
    static func dateFormatterForLongStyle() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("LLLL d, yyyy")
    }
    
    static func dateFormatterForMonthYear() -> NSDateFormatter {
        return DateFormatters.dateFormatterWithFormat("MMMM yyyy")
    }
    
    static let timeStampDateFormatter: NSDateFormatter = {
        return DateFormatters.dateFormatterWithFormat("MMM d, YYYY 'at' h:mm a")
    }()
    
    private static func dateFormatterWithFormat(format: String) -> NSDateFormatter {
        let threadDict = NSThread.currentThread().threadDictionary
        
        let formatter: NSDateFormatter
        
        if let _formatter = threadDict[format] as? NSDateFormatter {
            formatter = _formatter
        } else {
            formatter = NSDateFormatter()
            formatter.dateFormat = format
            
            threadDict[format] = formatter
        }
        
        return formatter
    }
}