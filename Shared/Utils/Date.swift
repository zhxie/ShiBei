//
//  Date.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/4.
//

import Foundation

extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        self.init(timeIntervalSinceReferenceDate: calendar.date(from: components)!.timeIntervalSinceReferenceDate)
    }
    
    var year: Int {
        return Int(self.formatted(.dateTime.year()))!
    }
    
    var month: Int {
        return Int(self.formatted(.dateTime.month(.defaultDigits)))!
    }
    
    var day: Int {
        return Int(self.formatted(.dateTime.day()))!
    }
    
    var isAnniversary: Bool {
        let now = Date.now
        return now.month == self.month && now.day == self.day
    }
    
    var isMonthiversary: Bool {
        return Date.now.month == self.month
    }
    
    var daySinceNow: Int {
        let interval = self.timeIntervalSinceNow
        
        return Int(floor(interval / 86400))
    }
    
    var dayToNow: Int {
        return -daySinceNow
    }
}
