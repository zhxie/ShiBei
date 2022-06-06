//
//  Date.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/4.
//

import Foundation

extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        self.init(timeIntervalSinceReferenceDate: calendar.date(from: components)!.timeIntervalSinceReferenceDate)
    }
    
    init(year: Int, month: Int, day: Int, timeZone: TimeZone) {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = timeZone
        
        self.init(timeIntervalSinceReferenceDate: calendar.date(from: components)!.timeIntervalSinceReferenceDate)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
    
    var isAnniversary: Bool {
        let now = Date.now
        
        return now.get(.month) == get(.month) && now.get(.day) == get(.day)
    }
    
    var isMonthiversary: Bool {
        Date.now.get(.day) == get(.day)
    }
    
    var dayToNow: Int {
        let interval = -self.timeIntervalSinceNow
        
        return Int(floor(interval / 86400))
    }
}
