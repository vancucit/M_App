//
//  StopWatch.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/12/17.
//  Copyright © 2017 Kuccu. All rights reserved.
//

struct StopWatch {
    
    var totalSeconds: Int
    
    var years: Int {
        return totalSeconds / 31536000
    }
    
    var days: Int {
        return (totalSeconds % 31536000) / 86400
    }
    
    var hours: Int {
        return (totalSeconds % 86400) / 3600
    }
    
    var minutes: Int {
        return (totalSeconds % 3600) / 60
    }
    
    var seconds: Int {
        return totalSeconds % 60
    }
    
    //simplified to what OP wanted
    var hoursMinutesAndSeconds: (hours: Int, minutes: Int, seconds: Int) {
        return (hours, minutes, seconds)
    }
}
extension StopWatch {
    
    var simpleTimeString: String {
        let hoursText = timeText(from: hours)
        let minutesText = timeText(from: minutes)
        let secondsText = timeText(from: seconds)
        if days > 0 {
            let dayText = timeText(from: days)

            return "\(dayText) days \(hoursText):\(minutesText):\(secondsText)"
        }else{
            if hours > 0 {
                return "\(hoursText):\(minutesText):\(secondsText)"
            }else{
                return "\(hoursText):\(minutesText):\(secondsText)"
            }
        }
        
    }
    
    private func timeText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}
