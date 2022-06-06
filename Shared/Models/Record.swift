//
//  Record.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/5.
//

import Foundation

extension Record {
    var wrappedId : UUID {
        id ?? UUID.empty
    }
    var wrappedTitle : String {
        title ?? ""
    }
    var wrappedDate : Date {
        guard let date = date else {
            return Date.now
        }
        
        return Date(year: date.get(.year), month: date.get(.month), day: date.get(.day))
    }
}
