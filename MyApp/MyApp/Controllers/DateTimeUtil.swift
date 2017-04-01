//
//  DateTimeUtil.swift
//  PipeFish
//
//  Created by Cuc Nguyen on 1/15/15.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


let kMinute = 60
let kDay = kMinute * 24
let kWeek = kDay * 7
let kMonth = kDay * 31
let kYear = kDay * 365

func NSDateTimeAgoLocalizedStrings(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")

}
func getDisplayDateTime(_ dateTime:Date?) -> String{
    let timeZone = TimeZone.current
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "HH:mm a"
    if dateTime != nil {
        let suffixStr =  dateFormatter.string(from: dateTime!)
        let displayStr = dateTime!.timeAgo + " " + suffixStr
        return displayStr
    }else{
        return ""
    }
}

func getDisplayDateTimeExpireOn(_ dateTime:Date?) -> String{
    let timeZone = TimeZone.current
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "dd/M/yyyy, H:mm"
    if dateTime != nil {
        let suffixStr =  dateFormatter.string(from: dateTime!)
        return suffixStr
//        return displayStr
    }else{
        return ""
    }
}

func dateFromStringAndFormat(_ dateString:String, formatStr:String) -> Date?{
    let timeZone = TimeZone(abbreviation: "UTC")
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = formatStr
    return dateFormatter.date(from: dateString)
}
func dateWithISO8601String(_ dateString:String) -> Date?{
    let timeZone = TimeZone(abbreviation: "UTC")
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    //2015-04-20T04:05:39.699+00:00
    //2017-03-08T05:54:00Z
    //remove 3 last charater
    let stringDate = dateString
    var realStr = stringDate
    if stringDate.characters.count >= 22 {
        realStr = (stringDate as NSString).substring(to: 22)
    }
    
    //find T and replac e'T'
    if realStr.range(of: "+") != nil {
        realStr = (realStr as NSString).substring(to: 19) + ".00"
    }
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
    return dateFormatter.date(from: realStr)
}
func compareDateTimeTwoString(_ str1:String, str2:String) -> Bool{
    let date1 = dateWithISO8601String(str1)
    let date2 = dateWithISO8601String(str2)
    return date2?.timeIntervalSinceNow < date1?.timeIntervalSinceNow
}

func stringFromUTCTime(_ dateTime:Date) -> String?{
    let timeZone = TimeZone(abbreviation: "UTC")
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return dateFormatter.string(from: dateTime)
}

func shortStringFromDate(_ dateTime:Date) -> String? {
    let timeZone = TimeZone(abbreviation: "UTC")
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: dateTime)
}
func shortDateFromString(_ dateString:String) -> Date? {
    
    let timeZone = TimeZone(abbreviation: "UTC")
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: dateString)
}

extension Date {
    var timeAgo: String {
        
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60
        
        var value: Int!
        
        if deltaSeconds < 5 {
            // Just Now
            return NSDateTimeAgoLocalizedStrings("Just now")
        } else if deltaSeconds < kMinute {
            // Seconds Ago
            return stringFromFormat("%%d %@seconds ago", withValue: deltaSeconds)
        } else if deltaSeconds < 120 {
            // A Minute Ago
            return NSDateTimeAgoLocalizedStrings("A minute ago")
        } else if deltaMinutes < kMinute {
            // Minutes Ago
            return stringFromFormat("%%d %@minutes ago", withValue: deltaMinutes)
        } else if deltaMinutes < 120 {
            // An Hour Ago
            return NSDateTimeAgoLocalizedStrings("An hour ago")
        } else if deltaMinutes < kDay {
            // Hours Ago
            value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat("%%d %@hours ago", withValue: value)
        } else if deltaMinutes < (kDay * 2) {
            // Yesterday
            return NSDateTimeAgoLocalizedStrings("Yesterday")
        } else if deltaMinutes < kWeek {
            // Days Ago
            value = Int(floor(Float(deltaMinutes / kDay)))
            return stringFromFormat("%%d %@days ago", withValue: value)
        } else if deltaMinutes < (kWeek * 2) {
            // Last Week
            return NSDateTimeAgoLocalizedStrings("Last week")
        } else if deltaMinutes < kMonth {
            // Weeks Ago
            value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat("%%d %@weeks ago", withValue: value)
        } else if deltaMinutes < (kDay * 61) {
            // Last month
            return NSDateTimeAgoLocalizedStrings("Last month")
        } else if deltaMinutes < kYear {
            // Month Ago
            value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat("%%d %@months ago", withValue: value)
        } else if deltaMinutes < (kDay * (kYear * 2)) {
            // Last Year
            return NSDateTimeAgoLocalizedStrings("Last Year")
        }
        
        // Years Ago
        value = Int(floor(Float(deltaMinutes / kYear)))
        return stringFromFormat("%%d %@years ago", withValue: value)
        
    }
    
    func stringFromFormat(_ format: String, withValue value: Int) -> String {
        
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(Double(value)))
        
        return String(format: NSDateTimeAgoLocalizedStrings(localeFormat), value)
    }
    
    func getLocaleFormatUnderscoresWithValue(_ value: Double) -> String {
//        Locale.preferredLanguages.first 
        let localeCode = Locale.preferredLanguages.first
        
        if localeCode == "ru" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
}
